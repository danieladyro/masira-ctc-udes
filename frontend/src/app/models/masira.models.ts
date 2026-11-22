export type UserRole = 'INVESTIGADOR' | 'SECRETARIO_CTC' | 'MIEMBRO_CTC' | 'ADMIN';

export type ProposalStatus =
  | 'BORRADOR'
  | 'SOMETIDO'
  | 'EN_REVISION_SECRETARIA'
  | 'SUBSANACION_SOLICITADA'
  | 'REENVIADO'
  | 'VISTO_BUENO_CTC'
  | 'EN_PLENO_CTC'
  | 'FAVORABLE'
  | 'FAVORABLE_CON_OBSERVACIONES'
  | 'RECHAZADO';

export type CtcConceptType = 'FAVORABLE' | 'FAVORABLE_CON_OBSERVACIONES' | 'RECHAZADO';

export interface MasiraUser {
  id: string;
  email: string;
  fullName: string;
  role: UserRole;
  academicUnit: string;
  researchGroup: string;
  isActive: boolean;
  passwordSetupToken?: string | null;
  createdAt: string;
}

export interface WorkTeamMember {
  nombre: string;
  rol: string;
  entidad: string;
  responsabilidades: string;
}

export interface RiskMatrixItem {
  tipoRiesgo:
    | 'Operacionales'
    | 'Administrativos'
    | 'Legales'
    | 'Financieros'
    | 'De costos'
    | 'De calendario';
  descripcion: string;
  probabilidad: 'No probable' | 'Poco probable' | 'Probable' | 'Muy probable';
  impacto: 'Nulo' | 'Leve' | 'Moderado' | 'Severo';
  medidasMitigacion: string;
}

export interface BudgetRubroItem {
  item: number;
  rubro: string;
  contrapartidaUdesEspecie: number;
  contrapartidaUdesEfectivo: number;
  aliadoEspecie: number;
  aliadoEfectivo: number;
  entidadConvocatoriaEfectivo: number;
  total: number;
}

export interface ScheduleActivityRow {
  objetivo: string;
  actividades: string;
  trimestres: boolean[]; // 12 quarters (Año 1: T1..T4, Año 2: T5..T8, Año 3: T9..T12)
}

export interface SupportingAttachment {
  id: string;
  proposalId: string;
  fileName: string;
  mimeType: string;
  fileSizeBytes: number;
  category: string;
  uploadedAt: string;
  contentDataUrl?: string;
}

export interface PointObservation {
  itemCode: string;
  itemLabel: string;
  observation: string;
  resolved: boolean;
}

export interface ProposalReviewRecord {
  id: string;
  proposalId: string;
  revisionNumber: number;
  reviewerName: string;
  stage: 'SECRETARIA_TECNICA' | 'PLENO_CTC';
  decision:
    | 'SOLICITAR_MODIFICACIONES'
    | 'VISTO_BUENO_CTC'
    | 'FAVORABLE'
    | 'FAVORABLE_CON_OBSERVACIONES'
    | 'RECHAZADO';
  generalSummary: string;
  pointObservations: PointObservation[];
  createdAt: string;
}

export interface CtcSingleUseToken {
  id: string;
  proposalId: string;
  revisionNumber: number;
  memberId: string;
  memberName: string;
  memberEmail: string;
  memberPosition: string;
  singleUseToken: string;
  isUsed: boolean;
  usedAt?: string;
  voteDecision?: string;
  signatureHash?: string;
}

export interface ProposalVersionAppendix {
  versionNumber: number;
  versionLabel: string;
  submittedAt: string;
  title: string;
  academicProgram: string;
  campus: string;
  backingGroup: string;
  groupLeader: string;
  researchLine: string;
  principalInvestigatorName: string;
  principalInvestigatorEmail: string;
  alliedEntityName: string;
  developmentLocation: string;
  callName: string;
  callType: string;
  callDeadline?: string;
  workTeam: WorkTeamMember[];
  problemAndJustification: string;
  generalObjective: string;
  specificObjectives: string;
  methodologyDesign: string;
  studySetting: string;
  participantsAndSampling: string;
  eligibilityCriteria: string;
  recruitmentPlan: string;
  dataCollectionTechniques: string;
  proceduresDescription: string;
  dataAnalysisPlan: string;
  ethicalConsiderations: string;
  expectedResults: string;
  possibleAlliances: string;
  riskMatrix: RiskMatrixItem[];
  budgetItems: BudgetRubroItem[];
  budgetTotal: number;
  scheduleItems: ScheduleActivityRow[];
}

export interface ResearchProposal {
  id: string;
  code: string;
  investigatorId: string;
  status: ProposalStatus;
  revisionCount: number;
  // 1.1 Información general (13 ítems exactos de CIM-FT-002-BUC)
  title: string;
  academicProgram: string;
  campus: string;
  backingGroup: string;
  groupLeader: string;
  researchLine: string;
  principalInvestigatorName: string;
  principalInvestigatorEmail: string;
  alliedEntityName: string;
  developmentLocation: string;
  callName: string;
  callType: string;
  callDeadline: string;
  // 1.2 Equipo de trabajo
  workTeam: WorkTeamMember[];
  // 2. Resumen Ejecutivo
  problemAndJustification: string; // 2.1 Planteamiento del problema y justificación
  generalObjective: string; // 2.1 Objetivo General
  specificObjectives: string; // 2.2 Objetivos Específicos
  // 2.3 Metodología
  methodologyDesign: string; // 2.3.1 Diseño metodológico
  studySetting: string; // 2.3.2 Ámbito del estudio
  participantsAndSampling: string; // 2.3.3 Participantes y muestreo
  eligibilityCriteria: string; // 2.3.4 Criterios de elegibilidad
  recruitmentPlan: string; // 2.3.5 Reclutamiento
  dataCollectionTechniques: string; // 2.3.6 Técnicas de recolección de información
  proceduresDescription: string; // 2.3.7 Procedimientos
  dataAnalysisPlan: string; // 2.3.8 Análisis de Datos
  ethicalConsiderations: string; // 2.3.9 Consideraciones éticas
  // 2.4 Resultados y Productos Esperados
  expectedResults: string;
  // 3. Posibles Alianzas y Trabajos en Red
  possibleAlliances: string;
  // 4. Análisis de Riesgos de Ejecución
  riskMatrix: RiskMatrixItem[];
  // 5. Presupuesto
  budgetItems: BudgetRubroItem[];
  budgetTotal: number;
  // 6. Cronograma de actividades
  scheduleItems: ScheduleActivityRow[];
  // Apéndices de versiones enviadas (Versión 1, Versión 2, ...)
  versionHistory: ProposalVersionAppendix[];
  // Anexos, Revisiones y Concepto CTC
  attachments: SupportingAttachment[];
  reviews: ProposalReviewRecord[];
  signatureTokens: CtcSingleUseToken[];
  ctcSessionDate?: string;
  ctcConcept?: CtcConceptType;
  ctcGeneralConceptNotes?: string;
  ctcModificationsCleared: boolean;
  submittedAt?: string;
  createdAt: string;
  updatedAt: string;
}

export interface EmailMessage {
  id: string;
  recipientEmail: string;
  recipientName: string;
  subject: string;
  bodyText: string;
  actionLink?: string;
  activationToken?: string;
  singleUseSignatureToken?: string;
  relatedProposalId?: string;
  relatedProposalCode?: string;
  category:
    | 'CREACION_USUARIO'
    | 'SOMETIMIENTO_INICIAL'
    | 'SOLICITUD_SUBSANACION'
    | 'REENVIO_SUBSANACION'
    | 'VISTO_BUENO_SECRETARIA'
    | 'TOKEN_FIRMA_CTC'
    | 'CONCEPTO_PLENO_CTC';
  isRead: boolean;
  createdAt: string;
}

export interface ReportFieldOption {
  key: string;
  label: string;
  section: string;
  selected: boolean;
}
