import { CommonModule } from '@angular/common';
import { Component, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import {
  CtcConceptType,
  MasiraUser,
  PointObservation,
  ReportFieldOption,
  ResearchProposal,
  UserRole
} from './models/masira.models';
import { MasiraStoreService } from './services/masira-store.service';
import { PdfGeneratorService } from './services/pdf-generator.service';

export type ActiveWorkspaceTab =
  | 'EXPEDIENTES'
  | 'FORMULARIO_CIM'
  | 'SECRETARIA_Y_PLENO'
  | 'REPORTES_CAMPOS'
  | 'USUARIOS_OAUTH'
  | 'CORREOS_SISTEMA';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  public readonly store = inject(MasiraStoreService);
  public readonly pdfService = inject(PdfGeneratorService);

  // Autenticación y Activación de Contraseña por Enlace (contra PostgreSQL)
  public readonly authMode = signal<'LOGIN' | 'ACTIVATE_PASSWORD'>('LOGIN');
  public loginEmail = '';
  public loginPassword = '';
  public activationTokenInput = '';
  public newPasswordInput = '';
  public confirmPasswordInput = '';

  // Navegación de la estación de trabajo
  public readonly activeTab = signal<ActiveWorkspaceTab>('EXPEDIENTES');
  public readonly activeFormSection = signal<number>(1);
  public readonly selectedProposalId = signal<string>('');
  public readonly focusedObservationIndex = signal<number | null>(null);
  public readonly statusBanner = signal<{ type: 'success' | 'warning' | 'error'; text: string } | null>(null);

  // Filtros de búsqueda de expedientes
  public searchQuery = '';
  public statusFilter = 'TODOS';

  // Borrador editable para el formulario CIM-FT-002-BUC
  public draftProposal: ResearchProposal = this.createBlankProposal();

  // Nuevo anexo documental
  public newAttachmentCategory = 'Aval de Grupo / Sustento Técnico';
  public newAttachmentCustomName = '';

  // Formulario de Revisión de Secretaría Técnica y Pleno CTC
  public secretaryDecision: 'SOLICITAR_MODIFICACIONES' | 'VISTO_BUENO_CTC' = 'SOLICITAR_MODIFICACIONES';
  public secretarySummary = '';
  public secretarySessionDate = '';
  public newObsCode = '2.3.3';
  public newObsLabel = '';
  public newObsText = '';
  public draftPointObservations: PointObservation[] = [];

  // Formulario de Concepto en Pleno del Comité Técnico Científico
  public plenaryConcept: CtcConceptType = 'FAVORABLE';
  public plenarySummary = '';

  // Firma con Token de Una Sola Utilización (Miembros del CTC)
  public memberSingleUseTokenInput = '';

  // Creación de Usuario desde Secretaría Técnica (JWT / OAuth2 Setup Link en PostgreSQL)
  public newUserFullName = '';
  public newUserEmail = '';
  public newUserRole: UserRole = 'INVESTIGADOR';
  public newUserUnit = '';
  public newUserGroup = '';

  // Selector dinámico de campos para el Listado de Proyectos
  public reportFields: ReportFieldOption[] = this.store.getDefaultReportFields();

  constructor() {
    this.checkUrlForActivationToken();
  }

  private checkUrlForActivationToken(): void {
    if (typeof window === 'undefined') {
      return;
    }
    const params = new URLSearchParams(window.location.search);
    const token = params.get('token');
    if (token && token.trim()) {
      this.openPasswordSetupWithToken(token.trim());
      window.history.replaceState({}, document.title, window.location.pathname);
    }
  }

  public readonly selectedProposal = computed(() => {
    const id = this.selectedProposalId();
    const visible = this.store.visibleProposals();
    return visible.find((p) => p.id === id) || visible[0] || null;
  });

  public activeFilteredProposal(): ResearchProposal | null {
    const list = this.filteredProposals();
    if (list.length === 0) {
      return null;
    }
    const id = this.selectedProposalId();
    return list.find((p) => p.id === id) || list[0];
  }

  public readonly canEditCurrentProposal = computed(() => {
    const user = this.store.currentUser();
    const prop = this.selectedProposal();
    if (!user) {
      return false;
    }
    if (user.role === 'MIEMBRO_CTC' || user.role === 'SECRETARIO_CTC') {
      // El Secretario y los Miembros del CTC solo evalúan propuestas, no las crean ni editan
      return false;
    }
    if (this.draftProposal.id.startsWith('new-') && (user.role === 'INVESTIGADOR' || user.role === 'ADMIN')) {
      return true;
    }
    if (!prop) {
      return user.role === 'INVESTIGADOR' || user.role === 'ADMIN';
    }
    const isOwner =
      user.role === 'ADMIN' ||
      prop.investigatorId === user.id ||
      prop.principalInvestigatorEmail.toLowerCase() === user.email.toLowerCase();
    if (!isOwner) {
      return false;
    }
    // Después de "Enviar Sometimiento Inicial" o "Nuevo Envío", el investigador principal NO puede modificar ningún campo
    // a menos que esté en BORRADOR o el Secretario/CTC haya solicitado modificaciones (SUBSANACION_SOLICITADA).
    const isEditableStage =
      prop.status === 'BORRADOR' ||
      prop.status === 'SUBSANACION_SOLICITADA' ||
      (prop.status === 'FAVORABLE_CON_OBSERVACIONES' && !prop.ctcModificationsCleared);
    return isEditableStage;
  });

  public readonly canReviewOrGrade = computed(() => {
    const user = this.store.currentUser();
    return !!user && (user.role === 'SECRETARIO_CTC' || user.role === 'ADMIN');
  });

  public showMessage(type: 'success' | 'warning' | 'error', text: string): void {
    this.statusBanner.set({ type, text });
  }

  public fillLoginEmail(email: string): void {
    this.loginEmail = email;
  }

  public async handleLogin(): Promise<void> {
    if (!this.loginEmail.trim() || !this.loginPassword) {
      this.showMessage('error', 'Ingrese su correo institucional y contraseña.');
      return;
    }
    const res = await this.store.loginWithCredentials(this.loginEmail, this.loginPassword);
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    const firstVisible = this.store.visibleProposals()[0];
    if (firstVisible) {
      this.selectProposal(firstVisible);
    } else {
      this.draftProposal = this.createBlankProposal();
    }
    this.activeTab.set('EXPEDIENTES');
    this.showMessage('success', res.message);
  }

  public openPasswordSetupWithToken(token: string): void {
    this.store.logout();
    this.authMode.set('ACTIVATE_PASSWORD');
    this.activationTokenInput = token;
    this.newPasswordInput = '';
    this.confirmPasswordInput = '';
    this.showMessage(
      'warning',
      `Enlace de correo abierto con token [${token}]. Cree su contraseña personal para guardarla en PostgreSQL.`
    );
  }

  public async handleActivatePassword(): Promise<void> {
    if (this.newPasswordInput !== this.confirmPasswordInput) {
      this.showMessage('error', 'La confirmación de contraseña no coincide.');
      return;
    }
    const res = await this.store.activateUserPassword(this.activationTokenInput, this.newPasswordInput);
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.user) {
      this.loginEmail = res.user.email;
      this.loginPassword = this.newPasswordInput;
    }
    this.authMode.set('LOGIN');
    this.showMessage('success', res.message);
  }

  public selectProposal(proposal: ResearchProposal): void {
    this.selectedProposalId.set(proposal.id);
    this.draftProposal = this.cloneProposal(proposal);
    this.memberSingleUseTokenInput = '';
  }

  public onProposalDropdownChange(proposalId: string): void {
    const found = this.store.visibleProposals().find((p) => p.id === proposalId);
    if (found) {
      this.selectProposal(found);
    }
  }

  public inspectSelectedProposalForm(): void {
    const prop = this.selectedProposal();
    if (prop) {
      this.selectProposal(prop);
      this.activeTab.set('FORMULARIO_CIM');
      this.activeFormSection.set(1);
    } else {
      this.showMessage('warning', 'No hay ningún expediente seleccionado para inspeccionar.');
    }
  }

  public startNewProposal(): void {
    const user = this.store.currentUser();
    if (!user || (user.role !== 'INVESTIGADOR' && user.role !== 'ADMIN')) {
      this.showMessage(
        'error',
        'El Secretario y los Miembros del Comité Técnico Científico solo evalúan propuestas; la creación de sometimientos iniciales es exclusiva del rol Investigador Principal.'
      );
      this.inspectSelectedProposalForm();
      return;
    }
    const blank = this.createBlankProposal();
    this.draftProposal = blank;
    this.selectedProposalId.set(blank.id);
    this.activeTab.set('FORMULARIO_CIM');
    this.activeFormSection.set(1);
    this.showMessage(
      'success',
      'Nueva plantilla CIM-FT-002-BUC lista para diligenciar. Al guardar o enviar se insertará en PostgreSQL.'
    );
  }

  public addWorkTeamRow(): void {
    this.draftProposal.workTeam.push({
      nombre: '',
      rol: '',
      entidad: '',
      responsabilidades: ''
    });
  }

  public removeWorkTeamRow(index: number): void {
    if (this.draftProposal.workTeam.length > 1) {
      this.draftProposal.workTeam.splice(index, 1);
    }
  }

  public addScheduleRow(): void {
    this.draftProposal.scheduleItems.push({
      objetivo: '',
      actividades: '',
      trimestres: [false, false, false, false, false, false, false, false, false, false, false, false]
    });
  }

  public removeScheduleRow(index: number): void {
    if (this.draftProposal.scheduleItems.length > 1) {
      this.draftProposal.scheduleItems.splice(index, 1);
    }
  }

  public recalculateDraftBudget(): void {
    let total = 0;
    this.draftProposal.budgetItems.forEach((row) => {
      row.total =
        (Number(row.contrapartidaUdesEspecie) || 0) +
        (Number(row.contrapartidaUdesEfectivo) || 0) +
        (Number(row.aliadoEspecie) || 0) +
        (Number(row.aliadoEfectivo) || 0) +
        (Number(row.entidadConvocatoriaEfectivo) || 0);
      total += row.total;
    });
    this.draftProposal.budgetTotal = total;
  }

  public getColumnTotal(
    col:
      | 'contrapartidaUdesEspecie'
      | 'contrapartidaUdesEfectivo'
      | 'aliadoEspecie'
      | 'aliadoEfectivo'
      | 'entidadConvocatoriaEfectivo'
  ): number {
    return this.draftProposal.budgetItems.reduce((acc, item) => acc + (Number(item[col]) || 0), 0);
  }

  public async handleFileInput(event: Event): Promise<void> {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) {
      return;
    }
    if (this.draftProposal.id.startsWith('new-')) {
      const saved = await this.store.saveOrSubmitProposal(this.draftProposal, false);
      if (saved.ok && saved.proposal) {
        this.draftProposal = this.cloneProposal(saved.proposal);
        this.selectedProposalId.set(saved.proposal.id);
      } else {
        this.showMessage('error', saved.message);
        return;
      }
    }

    const res = await this.store.addAttachmentToProposal(this.draftProposal.id, {
      fileName: file.name,
      mimeType: file.type || 'application/pdf',
      fileSizeBytes: file.size,
      category: this.newAttachmentCategory
    });
    input.value = '';
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.showMessage('success', res.message);
  }

  public async addQuickSupportingDocument(): Promise<void> {
    if (!this.newAttachmentCustomName.trim()) {
      this.showMessage('error', 'Escriba el nombre del anexo documental o seleccione un archivo.');
      return;
    }
    if (this.draftProposal.id.startsWith('new-')) {
      const saved = await this.store.saveOrSubmitProposal(this.draftProposal, false);
      if (saved.ok && saved.proposal) {
        this.draftProposal = this.cloneProposal(saved.proposal);
        this.selectedProposalId.set(saved.proposal.id);
      } else {
        this.showMessage('error', saved.message);
        return;
      }
    }
    const res = await this.store.addAttachmentToProposal(this.draftProposal.id, {
      fileName: this.newAttachmentCustomName.trim(),
      mimeType: 'application/pdf',
      fileSizeBytes: 312400,
      category: this.newAttachmentCategory
    });
    this.newAttachmentCustomName = '';
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.showMessage('success', res.message);
  }

  public async saveDraftOnly(): Promise<void> {
    if (!this.canEditCurrentProposal()) {
      this.showMessage('error', 'Su rol actual no tiene permisos para modificar esta propuesta.');
      return;
    }
    if (!this.draftProposal.title.trim()) {
      this.showMessage('error', 'Ingrese al menos el Título del Proyecto (Numeral 1.1) para guardar en PostgreSQL.');
      return;
    }
    this.recalculateDraftBudget();
    const res = await this.store.saveOrSubmitProposal(this.draftProposal, false);
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.showMessage('success', res.message);
  }

  public async submitProposalToCommittee(): Promise<void> {
    if (!this.canEditCurrentProposal()) {
      this.showMessage('error', 'Su rol actual no tiene permisos para enviar o modificar esta propuesta.');
      return;
    }
    if (!this.draftProposal.title.trim()) {
      this.showMessage('error', 'El Título del Proyecto (Numeral 1.1) es obligatorio antes de realizar el envío.');
      return;
    }
    this.recalculateDraftBudget();
    const res = await this.store.saveOrSubmitProposal(this.draftProposal, true);
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.showMessage('success', res.message);
  }

  public addPointObservationRow(): void {
    if (!this.newObsText.trim()) {
      return;
    }
    this.draftPointObservations.push({
      itemCode: this.newObsCode,
      itemLabel: this.newObsLabel,
      observation: this.newObsText.trim(),
      resolved: false
    });
    this.newObsText = '';
  }

  public removePointObservationRow(idx: number): void {
    this.draftPointObservations.splice(idx, 1);
  }

  public async submitSecretaryDecision(): Promise<void> {
    const prop = this.selectedProposal();
    if (!prop) {
      return;
    }
    if (!this.secretarySummary.trim()) {
      this.showMessage('error', 'Ingrese la síntesis de revisión para el Investigador Principal.');
      return;
    }
    const res = await this.store.submitSecretaryReview(
      prop.id,
      this.secretaryDecision,
      this.secretarySummary,
      [...this.draftPointObservations],
      this.secretarySessionDate
    );
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.draftPointObservations = [];
    this.showMessage('success', res.message);
  }

  public async submitPlenaryConcept(): Promise<void> {
    const prop = this.selectedProposal();
    if (!prop) {
      return;
    }
    if (!this.plenarySummary.trim()) {
      this.showMessage('error', 'Ingrese el acta / síntesis del pleno del Comité Técnico Científico.');
      return;
    }
    const res = await this.store.recordCtcPlenaryDecision(
      prop.id,
      this.plenaryConcept,
      this.plenarySummary,
      [...this.draftPointObservations]
    );
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.draftPointObservations = [];
    this.showMessage('success', res.message);
  }

  public isCurrentUsersToken(tok: { memberId?: string; memberEmail: string }): boolean {
    const user = this.store.currentUser();
    if (!user) {
      return false;
    }
    return (
      (!!tok.memberId && tok.memberId === user.id) ||
      tok.memberEmail.toLowerCase() === user.email.toLowerCase()
    );
  }

  public async consumeMemberSingleUseToken(): Promise<void> {
    const user = this.store.currentUser();
    if (!user || user.role === 'INVESTIGADOR') {
      this.showMessage('error', 'Solo los miembros del Comité Técnico Científico pueden firmar con token único.');
      return;
    }
    const prop = this.selectedProposal();
    if (!prop) {
      return;
    }
    const tokenInput = this.memberSingleUseTokenInput.trim();
    if (!tokenInput) {
      this.showMessage('error', 'Ingrese su token personal de una sola utilización.');
      return;
    }
    const matchingTok = prop.signatureTokens.find(
      (t) => t.singleUseToken.toUpperCase() === tokenInput.toUpperCase()
    );
    if (matchingTok && !this.isCurrentUsersToken(matchingTok)) {
      this.showMessage(
        'error',
        `Este token pertenece a ${matchingTok.memberName}. Usted solo puede firmar con su propio token asignado a ${user.email}.`
      );
      return;
    }
    const res = await this.store.signProposalWithSingleUseToken(prop.id, tokenInput);
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    if (res.proposal) {
      this.selectProposal(res.proposal);
    }
    this.showMessage('success', res.message);
  }

  public async handleCreateUserBySecretary(): Promise<void> {
    if (!this.newUserEmail.trim() || !this.newUserFullName.trim()) {
      this.showMessage('error', 'Debe ingresar el nombre completo y el correo electrónico institucional.');
      return;
    }
    const res = await this.store.createUserFromSecretary({
      email: this.newUserEmail,
      fullName: this.newUserFullName,
      role: this.newUserRole,
      academicUnit: this.newUserUnit,
      researchGroup: this.newUserGroup
    });
    if (!res.ok) {
      this.showMessage('error', res.message);
      return;
    }
    this.newUserFullName = '';
    this.newUserEmail = '';
    this.showMessage('success', res.message);
  }

  public filteredProposals(): ResearchProposal[] {
    const q = this.searchQuery.trim().toLowerCase();
    return this.store.visibleProposals().filter((p) => {
      const matchesStatus = this.statusFilter === 'TODOS' || p.status === this.statusFilter;
      const matchesText =
        !q ||
        p.code.toLowerCase().includes(q) ||
        p.title.toLowerCase().includes(q) ||
        p.principalInvestigatorName.toLowerCase().includes(q) ||
        p.researchLine.toLowerCase().includes(q);
      return matchesStatus && matchesText;
    });
  }

  public selectedReportColumns(): ReportFieldOption[] {
    return this.reportFields.filter((f) => f.selected);
  }

  public getReportCellValue(proposal: ResearchProposal, key: string): string {
    switch (key) {
      case 'code':
        return proposal.code;
      case 'title':
        return proposal.title;
      case 'principalInvestigatorName':
        return proposal.principalInvestigatorName;
      case 'principalInvestigatorEmail':
        return proposal.principalInvestigatorEmail;
      case 'academicProgram':
        return proposal.academicProgram;
      case 'campus':
        return proposal.campus;
      case 'backingGroup':
        return proposal.backingGroup;
      case 'groupLeader':
        return proposal.groupLeader;
      case 'researchLine':
        return proposal.researchLine;
      case 'alliedEntityName':
        return proposal.alliedEntityName;
      case 'callName':
        return proposal.callName;
      case 'callType':
        return proposal.callType;
      case 'callDeadline':
        return proposal.callDeadline;
      case 'generalObjective':
        return proposal.generalObjective;
      case 'methodologyDesign':
        return proposal.methodologyDesign;
      case 'budgetTotal':
        return '$ ' + (proposal.budgetTotal || 0).toLocaleString('es-CO');
      case 'status':
        return this.formatStatusLabel(proposal.status);
      case 'revisionCount':
        return `V${proposal.revisionCount}`;
      case 'ctcConcept':
        return proposal.ctcConcept || 'Pendiente';
      case 'signaturesCount': {
        const used = proposal.signatureTokens.filter((t) => t.isUsed).length;
        return `${used}/${proposal.signatureTokens.length} tokens firmados`;
      }
      default:
        return '';
    }
  }

  public exportCustomReportCsv(): void {
    const cols = this.selectedReportColumns();
    const rows = this.filteredProposals();
    const header = cols.map((c) => `"${c.label}"`).join(',');
    const body = rows
      .map((p) =>
        cols
          .map((c) => `"${this.getReportCellValue(p, c.key).replace(/"/g, '""')}"`)
          .join(',')
      )
      .join('\n');

    const csvContent = '\uFEFF' + header + '\n' + body;
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'Listado_Personalizado_Proyectos_CTC_MASIRA.csv';
    a.click();
    URL.revokeObjectURL(url);
    this.showMessage('success', 'Listado personalizado exportado en formato CSV.');
  }

  public exportCustomReportPdf(): void {
    this.pdfService.downloadCustomReportPdf(
      this.filteredProposals(),
      this.selectedReportColumns(),
      (p, k) => this.getReportCellValue(p, k)
    );
    this.showMessage('success', 'Informe PDF con los campos seleccionados generado correctamente.');
  }

  public formatStatusLabel(status: string): string {
    const map: Record<string, string> = {
      BORRADOR: 'Borrador en edición',
      SOMETIDO: 'Sometido a Secretaría',
      EN_REVISION_SECRETARIA: 'En Revisión Secretaría',
      SUBSANACION_SOLICITADA: 'Modificaciones Solicitadas',
      REENVIADO: 'Reenviado (Subsanado)',
      VISTO_BUENO_CTC: 'Visto Bueno · Agendado CTC',
      EN_PLENO_CTC: 'En Pleno Comité Técnico',
      FAVORABLE: 'Concepto Favorable',
      FAVORABLE_CON_OBSERVACIONES: 'Favorable con Observaciones',
      RECHAZADO: 'Concepto Rechazado'
    };
    return map[status] || status;
  }

  public formatRoleLabel(role: UserRole): string {
    const map: Record<UserRole, string> = {
      INVESTIGADOR: 'Investigador Principal',
      SECRETARIO_CTC: 'Secretario del Comité Técnico Científico',
      MIEMBRO_CTC: 'Miembro del Comité Técnico Científico',
      ADMIN: 'Administrador del Sistema'
    };
    return map[role];
  }

  public getNextRequiredActionForRole(proposal: ResearchProposal | null, user: MasiraUser | null): string {
    if (!proposal || !user) {
      return 'Seleccione un proyecto del listado o cree una nueva propuesta en PostgreSQL.';
    }
    if (user.role === 'INVESTIGADOR') {
      if (proposal.status === 'SUBSANACION_SOLICITADA') {
        return 'Acción requerida: El Secretario del CTC solicitó ajustes. El formulario con su información prediligenciada está habilitado para modificar y hacer clic en "Nuevo Envío".';
      }
      if (proposal.status === 'FAVORABLE_CON_OBSERVACIONES' && !proposal.ctcModificationsCleared) {
        return 'Acción requerida: Incorporar las aclaraciones demandadas por el CTC y hacer clic en "Nuevo Envío" para habilitar las firmas de los miembros en el reporte PDF.';
      }
      if (proposal.status === 'SOMETIDO' || proposal.status === 'REENVIADO') {
        return `Propuesta enviada (Versión ${proposal.revisionCount}) y bloqueada para edición mientras es revisada por el Secretario del Comité Técnico Científico.`;
      }
      if (proposal.status === 'VISTO_BUENO_CTC' || proposal.status === 'EN_PLENO_CTC') {
        return `Propuesta viabilizada por Secretaría Técnica para evaluación en el Pleno del CTC (${proposal.ctcSessionDate || 'programado'}). Formulario bloqueado para edición.`;
      }
      return 'Puede consultar su propuesta y sus versiones enviadas (Versión 1, Versión 2...) o descargar el PDF oficial compilado.';
    }
    if (user.role === 'SECRETARIO_CTC') {
      if (proposal.status === 'SOMETIDO' || proposal.status === 'REENVIADO') {
        return 'Acción requerida (Secretaría): Revisar ítems de CIM-FT-002-BUC y otorgar Visto Bueno o solicitar modificaciones al investigador.';
      }
      if (proposal.status === 'VISTO_BUENO_CTC' || proposal.status === 'EN_PLENO_CTC') {
        return 'Acción requerida (Secretaría): Registrar el concepto del Pleno CTC y emitir los tokens de un solo uso para firma de miembros.';
      }
      return 'Supervisión de firmas de tokens únicos y generación de reportes personalizados por campos.';
    }
    if (user.role === 'MIEMBRO_CTC') {
      const pending = proposal.signatureTokens.filter((t) => !t.isUsed).length;
      if (pending > 0) {
        return `Modo Consulta de Comité + Firma en Pleno: ${pending} token(s) de una sola utilización disponibles para firmar el concepto.`;
      }
      return 'Modo Consulta de Comité: Puede inspeccionar todos los proyectos y descargar informes PDF (sin edición ni calificación directa).';
    }
    return 'Administración integral de usuarios, roles, tokens criptográficos y trazabilidad en PostgreSQL.';
  }

  public getUsedSignaturesCount(proposal: ResearchProposal): number {
    return proposal.signatureTokens.filter((t) => t.isUsed).length;
  }

  private cloneProposal(p: ResearchProposal): ResearchProposal {
    return JSON.parse(JSON.stringify(p));
  }

  private createBlankProposal(): ResearchProposal {
    const user = this.store.currentUser();
    return {
      id: `new-${Date.now()}`,
      code: 'NUEVO-RADICADO',
      investigatorId: user?.id || '',
      status: 'BORRADOR',
      revisionCount: 1,
      title: '',
      academicProgram: '',
      campus: '',
      backingGroup: '',
      groupLeader: '',
      researchLine: '',
      principalInvestigatorName: '',
      principalInvestigatorEmail: '',
      alliedEntityName: '',
      developmentLocation: '',
      callName: '',
      callType: '',
      callDeadline: '',
      workTeam: [
        {
          nombre: '',
          rol: '',
          entidad: '',
          responsabilidades: ''
        }
      ],
      problemAndJustification: '',
      generalObjective: '',
      specificObjectives: '',
      methodologyDesign: '',
      studySetting: '',
      participantsAndSampling: '',
      eligibilityCriteria: '',
      recruitmentPlan: '',
      dataCollectionTechniques: '',
      proceduresDescription: '',
      dataAnalysisPlan: '',
      ethicalConsiderations: '',
      expectedResults: '',
      possibleAlliances: '',
      riskMatrix: this.store.createDefaultRiskMatrix(),
      budgetItems: this.store.createDefaultBudgetItems(),
      budgetTotal: 0,
      scheduleItems: this.store.createDefaultSchedule(),
      versionHistory: [],
      attachments: [],
      reviews: [],
      signatureTokens: [],
      ctcModificationsCleared: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
  }
}
