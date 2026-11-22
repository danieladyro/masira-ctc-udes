import { Injectable, computed, signal } from '@angular/core';
import {
  BudgetRubroItem,
  CtcConceptType,
  EmailMessage,
  MasiraUser,
  PointObservation,
  ReportFieldOption,
  ResearchProposal,
  RiskMatrixItem,
  ScheduleActivityRow,
  UserRole
} from '../models/masira.models';

@Injectable({
  providedIn: 'root'
})
export class MasiraStoreService {
  private readonly apiUrl = '/api';
  private readonly tokenStorageKey = 'masira_ctc_jwt_token';
  private readonly userStorageKey = 'masira_ctc_current_user';

  public readonly users = signal<MasiraUser[]>([]);
  public readonly pendingUsers = signal<MasiraUser[]>([]);
  public readonly proposals = signal<ResearchProposal[]>([]);
  public readonly emails = signal<EmailMessage[]>([]);
  public readonly currentUser = signal<MasiraUser | null>(null);
  public readonly jwtToken = signal<string | null>(null);
  public readonly isLoading = signal<boolean>(false);

  public readonly visibleProposals = computed(() => this.proposals());

  constructor() {
    this.restoreSessionFromStorage();
    this.loadPendingUsersFromApi();
  }

  private restoreSessionFromStorage(): void {
    if (typeof window === 'undefined' || !window.sessionStorage) {
      return;
    }
    try {
      const savedToken = window.sessionStorage.getItem(this.tokenStorageKey);
      const savedUserJson = window.sessionStorage.getItem(this.userStorageKey);
      if (savedToken && savedUserJson) {
        const parsedUser = JSON.parse(savedUserJson) as MasiraUser;
        this.jwtToken.set(savedToken);
        this.currentUser.set(parsedUser);
        this.refreshAllDataFromDatabase();
      }
    } catch {
      window.sessionStorage.removeItem(this.tokenStorageKey);
      window.sessionStorage.removeItem(this.userStorageKey);
    }
  }

  private authHeaders(): Record<string, string> {
    const token = this.jwtToken();
    const headers: Record<string, string> = {
      'Content-Type': 'application/json'
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
  }

  private mapBackendEmail(raw: any): EmailMessage {
    return {
      id: raw.id,
      recipientEmail: raw.recipientEmail,
      recipientName: raw.recipientName,
      subject: raw.subject,
      bodyText: raw.bodyText,
      actionLink: raw.actionLink,
      activationToken:
        raw.emailCategory === 'CREACION_USUARIO' && raw.actionLink
          ? raw.actionLink.replace('/activar-cuenta?token=', '')
          : undefined,
      singleUseSignatureToken:
        raw.emailCategory === 'TOKEN_FIRMA_CTC' ? raw.actionLink : undefined,
      relatedProposalCode: raw.relatedProposalCode,
      category: raw.emailCategory,
      isRead: raw.isRead,
      createdAt: raw.createdAt
    };
  }

  private mapBackendProposal(raw: any): ResearchProposal {
    return {
      id: raw.id,
      code: raw.code,
      investigatorId: raw.investigatorId,
      status: raw.status,
      revisionCount: raw.revisionCount,
      title: raw.title || '',
      academicProgram: raw.academicProgram || '',
      campus: raw.campus || '',
      backingGroup: raw.backingGroup || '',
      groupLeader: raw.groupLeader || '',
      researchLine: raw.researchLine || '',
      principalInvestigatorName: raw.principalInvestigatorName || '',
      principalInvestigatorEmail: raw.principalInvestigatorEmail || '',
      alliedEntityName: raw.alliedEntityName || '',
      developmentLocation: raw.developmentLocation || '',
      callName: raw.callName || '',
      callType: raw.callType || '',
      callDeadline: raw.callDeadline || '',
      workTeam: Array.isArray(raw.workTeam) ? raw.workTeam : [],
      problemAndJustification: raw.problemAndJustification || '',
      generalObjective: raw.generalObjective || '',
      specificObjectives: raw.specificObjectives || '',
      methodologyDesign: raw.methodologyDesign || '',
      studySetting: raw.studySetting || '',
      participantsAndSampling: raw.participantsAndSampling || '',
      eligibilityCriteria: raw.eligibilityCriteria || '',
      recruitmentPlan: raw.recruitmentPlan || '',
      dataCollectionTechniques: raw.dataCollectionTechniques || '',
      proceduresDescription: raw.proceduresDescription || '',
      dataAnalysisPlan: raw.dataAnalysisPlan || '',
      ethicalConsiderations: raw.ethicalConsiderations || '',
      expectedResults: raw.expectedResults || '',
      possibleAlliances: raw.possibleAlliances || '',
      riskMatrix: Array.isArray(raw.riskMatrix) && raw.riskMatrix.length > 0
        ? raw.riskMatrix
        : this.createDefaultRiskMatrix(),
      budgetItems: Array.isArray(raw.budgetItems) && raw.budgetItems.length > 0
        ? raw.budgetItems
        : this.createDefaultBudgetItems(),
      budgetTotal: Number(raw.budgetTotal) || 0,
      scheduleItems: Array.isArray(raw.scheduleItems) && raw.scheduleItems.length > 0
        ? raw.scheduleItems
        : this.createDefaultSchedule(),
      versionHistory: Array.isArray(raw.versionHistory)
        ? raw.versionHistory.map((v: any, idx: number) => ({
            versionNumber: Number(v.versionNumber) || idx + 1,
            versionLabel: v.versionLabel || `Versión ${Number(v.versionNumber) || idx + 1}`,
            submittedAt: v.submittedAt || raw.submittedAt || raw.updatedAt || '',
            title: v.title || '',
            academicProgram: v.academicProgram || '',
            campus: v.campus || '',
            backingGroup: v.backingGroup || '',
            groupLeader: v.groupLeader || '',
            researchLine: v.researchLine || '',
            principalInvestigatorName: v.principalInvestigatorName || '',
            principalInvestigatorEmail: v.principalInvestigatorEmail || '',
            alliedEntityName: v.alliedEntityName || '',
            developmentLocation: v.developmentLocation || '',
            callName: v.callName || '',
            callType: v.callType || '',
            callDeadline: v.callDeadline || '',
            workTeam: Array.isArray(v.workTeam) ? v.workTeam : [],
            problemAndJustification: v.problemAndJustification || '',
            generalObjective: v.generalObjective || '',
            specificObjectives: v.specificObjectives || '',
            methodologyDesign: v.methodologyDesign || '',
            studySetting: v.studySetting || '',
            participantsAndSampling: v.participantsAndSampling || '',
            eligibilityCriteria: v.eligibilityCriteria || '',
            recruitmentPlan: v.recruitmentPlan || '',
            dataCollectionTechniques: v.dataCollectionTechniques || '',
            proceduresDescription: v.proceduresDescription || '',
            dataAnalysisPlan: v.dataAnalysisPlan || '',
            ethicalConsiderations: v.ethicalConsiderations || '',
            expectedResults: v.expectedResults || '',
            possibleAlliances: v.possibleAlliances || '',
            riskMatrix: Array.isArray(v.riskMatrix) ? v.riskMatrix : [],
            budgetItems: Array.isArray(v.budgetItems) ? v.budgetItems : [],
            budgetTotal: Number(v.budgetTotal) || 0,
            scheduleItems: Array.isArray(v.scheduleItems) ? v.scheduleItems : []
          }))
        : [],
      attachments: (raw.attachments || []).map((a: any) => ({
        id: a.id,
        proposalId: a.proposalId,
        fileName: a.fileName,
        mimeType: a.mimeType,
        fileSizeBytes: a.fileSizeBytes,
        category: a.category,
        uploadedAt: a.createdAt || new Date().toISOString()
      })),
      reviews: (raw.reviews || []).map((r: any) => ({
        id: r.id,
        proposalId: r.proposalId,
        revisionNumber: r.revisionNumber,
        reviewerName: r.reviewerName,
        stage: r.stage,
        decision: r.decision,
        generalSummary: r.generalSummary,
        pointObservations: r.pointObservations || [],
        createdAt: r.createdAt
      })),
      signatureTokens: (raw.signatureTokens || []).map((t: any) => ({
        id: t.id,
        proposalId: t.proposalId,
        revisionNumber: t.revisionNumber,
        memberId: t.memberId,
        memberName: t.memberName,
        memberEmail: t.memberEmail,
        memberPosition: t.memberPosition,
        singleUseToken: t.singleUseToken,
        isUsed: t.isUsed,
        usedAt: t.usedAt,
        voteDecision: t.voteDecision,
        signatureHash: t.signatureHash
      })),
      ctcSessionDate: raw.ctcSessionDate || '',
      ctcConcept: raw.ctcConcept,
      ctcGeneralConceptNotes: raw.ctcGeneralConceptNotes,
      ctcModificationsCleared: !!raw.ctcModificationsCleared,
      submittedAt: raw.submittedAt,
      createdAt: raw.createdAt,
      updatedAt: raw.updatedAt
    };
  }

  public async loadPendingUsersFromApi(): Promise<void> {
    try {
      const res = await fetch(`${this.apiUrl}/auth/pending-users`);
      if (res.ok) {
        const data = await res.json();
        this.pendingUsers.set(data);
      }
    } catch (e) {
      console.error('Error cargando usuarios pendientes desde PostgreSQL:', e);
    }
  }

  public async refreshAllDataFromDatabase(): Promise<void> {
    if (!this.jwtToken()) {
      return;
    }
    this.isLoading.set(true);
    try {
      const [propRes, emailRes] = await Promise.all([
        fetch(`${this.apiUrl}/proposals`, { headers: this.authHeaders() }),
        fetch(`${this.apiUrl}/emails`, { headers: this.authHeaders() })
      ]);

      if (propRes.ok) {
        const rawProposals = await propRes.json();
        this.proposals.set(rawProposals.map((p: any) => this.mapBackendProposal(p)));
      }

      if (emailRes.ok) {
        const rawEmails = await emailRes.json();
        this.emails.set(rawEmails.map((e: any) => this.mapBackendEmail(e)));
      }

      const role = this.currentUser()?.role;
      if (role && role !== 'INVESTIGADOR') {
        const usersRes = await fetch(`${this.apiUrl}/users`, { headers: this.authHeaders() });
        if (usersRes.ok) {
          const rawUsers = await usersRes.json();
          this.users.set(rawUsers);
        }
      }
    } finally {
      this.isLoading.set(false);
    }
  }

  public async loginWithCredentials(
    email: string,
    password: string
  ): Promise<{ ok: boolean; message: string }> {
    this.isLoading.set(true);
    try {
      const res = await fetch(`${this.apiUrl}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: email.trim(), password })
      });
      const body = await res.json();
      if (!res.ok) {
        return { ok: false, message: body.error || 'Error de autenticación contra PostgreSQL.' };
      }

      this.jwtToken.set(body.accessToken);
      this.currentUser.set(body.user);
      if (typeof window !== 'undefined' && window.sessionStorage) {
        window.sessionStorage.setItem(this.tokenStorageKey, body.accessToken);
        window.sessionStorage.setItem(this.userStorageKey, JSON.stringify(body.user));
      }
      await this.refreshAllDataFromDatabase();
      return {
        ok: true,
        message: `Autenticación JWT exitosa en PostgreSQL: ${body.user.fullName} (${body.user.role})`
      };
    } catch (err) {
      return {
        ok: false,
        message: 'No se pudo conectar con la REST API en Rust (/api/auth/login).'
      };
    } finally {
      this.isLoading.set(false);
    }
  }

  public logout(): void {
    this.currentUser.set(null);
    this.jwtToken.set(null);
    this.proposals.set([]);
    this.users.set([]);
    if (typeof window !== 'undefined' && window.sessionStorage) {
      window.sessionStorage.removeItem(this.tokenStorageKey);
      window.sessionStorage.removeItem(this.userStorageKey);
    }
    this.loadPendingUsersFromApi();
  }

  public async createUserFromSecretary(payload: {
    email: string;
    fullName: string;
    role: UserRole;
    academicUnit: string;
    researchGroup: string;
  }): Promise<{ ok: boolean; message: string; token?: string }> {
    try {
      const res = await fetch(`${this.apiUrl}/users`, {
        method: 'POST',
        headers: this.authHeaders(),
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'Error creando usuario en PostgreSQL.' };
      }
      await this.refreshAllDataFromDatabase();
      await this.loadPendingUsersFromApi();
      return {
        ok: true,
        token: data.passwordSetupToken,
        message: data.message
      };
    } catch {
      return { ok: false, message: 'Error de red al comunicarse con el backend en Rust.' };
    }
  }

  public async activateUserPassword(
    token: string,
    newPassword: string
  ): Promise<{ ok: boolean; message: string; user?: MasiraUser }> {
    try {
      const res = await fetch(`${this.apiUrl}/auth/set-password`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token: token.trim(), newPassword })
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'No se pudo activar la contraseña.' };
      }
      await this.loadPendingUsersFromApi();
      return {
        ok: true,
        user: data.user,
        message: data.message
      };
    } catch {
      return { ok: false, message: 'Error de conexión con la API en Rust.' };
    }
  }

  public async saveOrSubmitProposal(
    draft: ResearchProposal,
    submitNow: boolean
  ): Promise<{ ok: boolean; proposal?: ResearchProposal; message: string }> {
    const isNew = draft.id.startsWith('new-');
    const url = isNew ? `${this.apiUrl}/proposals` : `${this.apiUrl}/proposals/${draft.id}`;
    const method = isNew ? 'POST' : 'PUT';

    const payload = {
      title: draft.title,
      academicProgram: draft.academicProgram,
      campus: draft.campus,
      backingGroup: draft.backingGroup,
      groupLeader: draft.groupLeader,
      researchLine: draft.researchLine,
      principalInvestigatorName: draft.principalInvestigatorName,
      principalInvestigatorEmail: draft.principalInvestigatorEmail,
      alliedEntityName: draft.alliedEntityName,
      developmentLocation: draft.developmentLocation,
      callName: draft.callName,
      callType: draft.callType,
      callDeadline: draft.callDeadline || null,
      workTeam: draft.workTeam,
      problemAndJustification: draft.problemAndJustification,
      generalObjective: draft.generalObjective,
      specificObjectives: draft.specificObjectives,
      methodologyDesign: draft.methodologyDesign,
      studySetting: draft.studySetting,
      participantsAndSampling: draft.participantsAndSampling,
      eligibilityCriteria: draft.eligibilityCriteria,
      recruitmentPlan: draft.recruitmentPlan,
      dataCollectionTechniques: draft.dataCollectionTechniques,
      proceduresDescription: draft.proceduresDescription,
      dataAnalysisPlan: draft.dataAnalysisPlan,
      ethicalConsiderations: draft.ethicalConsiderations,
      expectedResults: draft.expectedResults,
      possibleAlliances: draft.possibleAlliances,
      riskMatrix: draft.riskMatrix,
      budgetItems: draft.budgetItems,
      scheduleItems: draft.scheduleItems,
      submitNow
    };

    try {
      const res = await fetch(url, {
        method,
        headers: this.authHeaders(),
        body: JSON.stringify(payload)
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'Error guardando la propuesta en PostgreSQL.' };
      }
      const mapped = this.mapBackendProposal(data);
      await this.refreshAllDataFromDatabase();
      return {
        ok: true,
        proposal: mapped,
        message: submitNow
          ? `Propuesta ${mapped.code} (Versión V${mapped.revisionCount}) guardada en PostgreSQL y enviada al Secretario del CTC.`
          : `Borrador ${mapped.code} guardado en PostgreSQL.`
      };
    } catch {
      return { ok: false, message: 'Error de red al guardar en el backend Rust.' };
    }
  }

  public async addAttachmentToProposal(
    proposalId: string,
    attachment: { fileName: string; mimeType: string; fileSizeBytes: number; category: string }
  ): Promise<{ ok: boolean; proposal?: ResearchProposal; message: string }> {
    try {
      const res = await fetch(`${this.apiUrl}/proposals/${proposalId}/attachments`, {
        method: 'POST',
        headers: this.authHeaders(),
        body: JSON.stringify(attachment)
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'No se pudo guardar el anexo en PostgreSQL.' };
      }
      const mapped = this.mapBackendProposal(data);
      await this.refreshAllDataFromDatabase();
      return {
        ok: true,
        proposal: mapped,
        message: `Anexo "${attachment.fileName}" registrado en PostgreSQL.`
      };
    } catch {
      return { ok: false, message: 'Error al subir anexo a la API Rust.' };
    }
  }

  public async submitSecretaryReview(
    proposalId: string,
    decision: 'SOLICITAR_MODIFICACIONES' | 'VISTO_BUENO_CTC',
    generalSummary: string,
    pointObservations: PointObservation[],
    ctcSessionDate?: string
  ): Promise<{ ok: boolean; proposal?: ResearchProposal; message: string }> {
    try {
      const res = await fetch(`${this.apiUrl}/proposals/${proposalId}/secretary-review`, {
        method: 'POST',
        headers: this.authHeaders(),
        body: JSON.stringify({
          decision,
          generalSummary,
          pointObservations,
          ctcSessionDate: ctcSessionDate || null
        })
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'Error al registrar revisión en PostgreSQL.' };
      }
      const mapped = this.mapBackendProposal(data);
      await this.refreshAllDataFromDatabase();
      return {
        ok: true,
        proposal: mapped,
        message:
          decision === 'VISTO_BUENO_CTC'
            ? `Visto Bueno guardado en PostgreSQL para ${mapped.code}. Se registró notificación por correo al Investigador Principal.`
            : `Solicitud de modificaciones guardada en PostgreSQL para ${mapped.code}. Se notificó al Investigador Principal.`
      };
    } catch {
      return { ok: false, message: 'Error de comunicación con la API Rust.' };
    }
  }

  public async recordCtcPlenaryDecision(
    proposalId: string,
    concept: CtcConceptType,
    generalSummary: string,
    pointObservations: PointObservation[]
  ): Promise<{ ok: boolean; proposal?: ResearchProposal; message: string }> {
    try {
      const res = await fetch(`${this.apiUrl}/proposals/${proposalId}/ctc-plenary`, {
        method: 'POST',
        headers: this.authHeaders(),
        body: JSON.stringify({
          concept,
          generalSummary,
          pointObservations,
          generateMemberTokens: true
        })
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'Error guardando el concepto del pleno en PostgreSQL.' };
      }
      const mapped = this.mapBackendProposal(data);
      await this.refreshAllDataFromDatabase();
      return {
        ok: true,
        proposal: mapped,
        message: `Concepto [${concept}] y ${mapped.signatureTokens.length} tokens de un solo uso guardados en PostgreSQL.`
      };
    } catch {
      return { ok: false, message: 'Error de red al comunicarse con el backend Rust.' };
    }
  }

  public async signProposalWithSingleUseToken(
    proposalId: string,
    tokenString: string
  ): Promise<{ ok: boolean; proposal?: ResearchProposal; message: string }> {
    try {
      const res = await fetch(`${this.apiUrl}/proposals/${proposalId}/sign-token`, {
        method: 'POST',
        headers: this.authHeaders(),
        body: JSON.stringify({
          singleUseToken: tokenString.trim(),
          voteDecision: 'APROBADO'
        })
      });
      const data = await res.json();
      if (!res.ok) {
        return { ok: false, message: data.error || 'Token inválido o ya utilizado.' };
      }
      const mapped = this.mapBackendProposal(data);
      await this.refreshAllDataFromDatabase();
      return {
        ok: true,
        proposal: mapped,
        message: `Firma con token único [${tokenString.trim()}] verificada y persistida en PostgreSQL.`
      };
    } catch {
      return { ok: false, message: 'Error de red al verificar el token en la API Rust.' };
    }
  }

  public createDefaultBudgetItems(): BudgetRubroItem[] {
    const rubros = [
      'Talento humano',
      'Equipos y software',
      'Capacitación',
      'Servicios tecnológicos y pruebas',
      'Materiales, insumos y documentación',
      'Protección de conocimiento y divulgación',
      'Gastos de viaje',
      'Infraestructura',
      'Administrativos',
      'Seguimiento',
      'Otros'
    ];
    return rubros.map((rubro, idx) => ({
      item: idx + 1,
      rubro,
      contrapartidaUdesEspecie: 0,
      contrapartidaUdesEfectivo: 0,
      aliadoEspecie: 0,
      aliadoEfectivo: 0,
      entidadConvocatoriaEfectivo: 0,
      total: 0
    }));
  }

  public createDefaultRiskMatrix(): RiskMatrixItem[] {
    const tipos: RiskMatrixItem['tipoRiesgo'][] = [
      'Operacionales',
      'Administrativos',
      'Legales',
      'Financieros',
      'De costos',
      'De calendario'
    ];
    return tipos.map((tipoRiesgo) => ({
      tipoRiesgo,
      descripcion: '',
      probabilidad: 'Poco probable',
      impacto: 'Leve',
      medidasMitigacion: ''
    }));
  }

  public createDefaultSchedule(): ScheduleActivityRow[] {
    return [
      {
        objetivo: '',
        actividades: '',
        trimestres: [false, false, false, false, false, false, false, false, false, false, false, false]
      },
      {
        objetivo: '',
        actividades: '',
        trimestres: [false, false, false, false, false, false, false, false, false, false, false, false]
      },
      {
        objetivo: '',
        actividades: '',
        trimestres: [false, false, false, false, false, false, false, false, false, false, false, false]
      }
    ];
  }

  public getDefaultReportFields(): ReportFieldOption[] {
    return [
      { key: 'code', label: 'Código Radicado', section: 'Control', selected: true },
      { key: 'title', label: '1.1 Título del Proyecto', section: '1. Identificación', selected: true },
      { key: 'principalInvestigatorName', label: '1.1 Investigador Principal', section: '1. Identificación', selected: true },
      { key: 'principalInvestigatorEmail', label: '1.1 Correo Investigador', section: '1. Identificación', selected: false },
      { key: 'academicProgram', label: '1.1 Programa o Unidad Académica', section: '1. Identificación', selected: true },
      { key: 'campus', label: '1.1 Campus', section: '1. Identificación', selected: false },
      { key: 'backingGroup', label: '1.1 Grupo de Respaldo', section: '1. Identificación', selected: true },
      { key: 'groupLeader', label: '1.1 Líder del Grupo', section: '1. Identificación', selected: false },
      { key: 'researchLine', label: '1.1 Línea de Investigación', section: '1. Identificación', selected: true },
      { key: 'alliedEntityName', label: '1.1 Entidad Aliada', section: '1. Identificación', selected: false },
      { key: 'callName', label: '1.1 Nombre de la Convocatoria', section: '1. Identificación', selected: true },
      { key: 'callType', label: '1.1 Tipo de Convocatoria', section: '1. Identificación', selected: false },
      { key: 'callDeadline', label: '1.1 Fecha Límite Convocatoria', section: '1. Identificación', selected: false },
      { key: 'generalObjective', label: '2.1 Objetivo General', section: '2. Resumen Ejecutivo', selected: false },
      { key: 'methodologyDesign', label: '2.3.1 Diseño Metodológico', section: '2. Resumen Ejecutivo', selected: false },
      { key: 'budgetTotal', label: '5. Presupuesto Total (COP)', section: '5. Presupuesto', selected: true },
      { key: 'status', label: 'Estado Actual en Plataforma', section: 'Evaluación CTC', selected: true },
      { key: 'revisionCount', label: 'Versión de Envío', section: 'Evaluación CTC', selected: true },
      { key: 'ctcConcept', label: 'Concepto Pleno CTC', section: 'Evaluación CTC', selected: true },
      { key: 'signaturesCount', label: 'Firmas con Token Único', section: 'Evaluación CTC', selected: true }
    ];
  }
}
