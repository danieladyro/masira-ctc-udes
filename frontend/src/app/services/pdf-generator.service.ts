import { Injectable } from '@angular/core';
import { jsPDF } from 'jspdf';
import { ReportFieldOption, ResearchProposal } from '../models/masira.models';

@Injectable({
  providedIn: 'root'
})
export class PdfGeneratorService {
  private formatCurrency(value: number): string {
    return '$ ' + (value || 0).toLocaleString('es-CO');
  }

  public downloadProposalCimPdf(proposal: ResearchProposal): void {
    const doc = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'letter'
    });

    let y = 18;
    const pageWidth = 215.9;
    const leftMargin = 16;
    const contentWidth = pageWidth - leftMargin * 2;

    const drawOfficialHeader = () => {
      // Marco superior institucional CIM-FT-002-BUC
      doc.setDrawColor(11, 37, 69);
      doc.setLineWidth(0.5);
      doc.rect(leftMargin, 10, contentWidth, 22);
      doc.line(leftMargin + 62, 10, leftMargin + 62, 32);
      doc.line(leftMargin + 142, 10, leftMargin + 142, 32);
      doc.line(leftMargin + 62, 19, leftMargin + contentWidth, 19);

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(10.5);
      doc.setTextColor(11, 37, 69);
      doc.text('UNIVERSIDAD DE SANTANDER', leftMargin + 3, 16);
      doc.setFontSize(8.5);
      doc.setTextColor(15, 118, 110);
      doc.text('INSTITUTO DE INVESTIGACION MASIRA', leftMargin + 3, 21.5);
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7);
      doc.setTextColor(60, 75, 95);
      doc.text('VIGILADA MINEDUCACION | SNIES 2832', leftMargin + 3, 28.5);

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(10);
      doc.setTextColor(11, 37, 69);
      doc.text('Centro de Investigacion MASIRA', leftMargin + 102, 15.5, { align: 'center' });
      doc.setFontSize(9);
      doc.text('SOMETIMIENTO INICIAL', leftMargin + 102, 24.5, { align: 'center' });
      doc.text('CIM-FT-002-BUC', leftMargin + 102, 29.2, { align: 'center' });

      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8.5);
      doc.text('Version: 00', leftMargin + 162, 24.5, { align: 'center' });
      doc.setFontSize(7.5);
      doc.text(`Rad: ${proposal.code}`, leftMargin + 162, 29.2, { align: 'center' });
      y = 38;
    };

    const ensureSpace = (neededMm: number) => {
      if (y + neededMm > 260) {
        doc.addPage();
        drawOfficialHeader();
      }
    };

    const writeSectionHeading = (title: string) => {
      ensureSpace(12);
      doc.setFillColor(11, 37, 69);
      doc.rect(leftMargin, y, contentWidth, 7, 'F');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9.5);
      doc.setTextColor(255, 255, 255);
      doc.text(title, leftMargin + 3, y + 4.8);
      y += 10;
    };

    const writeSubHeading = (subtitle: string) => {
      ensureSpace(9);
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9.2);
      doc.setTextColor(11, 37, 69);
      doc.text(subtitle, leftMargin, y);
      y += 5;
    };

    const writeKeyValueRow = (label: string, value: string) => {
      const wrappedVal = doc.splitTextToSize(value || 'Sin registrar', contentWidth - 66);
      const rowHeight = Math.max(6.5, wrappedVal.length * 4.5 + 2);
      ensureSpace(rowHeight + 1);
      doc.setDrawColor(197, 211, 222);
      doc.setFillColor(246, 248, 247);
      doc.rect(leftMargin, y, 64, rowHeight, 'FD');
      doc.setFillColor(255, 255, 255);
      doc.rect(leftMargin + 64, y, contentWidth - 64, rowHeight, 'FD');

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(8.2);
      doc.setTextColor(11, 37, 69);
      doc.text(label, leftMargin + 2, y + 4.4);

      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8.4);
      doc.setTextColor(20, 35, 55);
      doc.text(wrappedVal, leftMargin + 66, y + 4.4);
      y += rowHeight;
    };

    const writeNarrativeBlock = (label: string, text: string) => {
      writeSubHeading(label);
      const lines = doc.splitTextToSize(text || 'Sin contenido registrado.', contentWidth - 4);
      const blockHeight = Math.max(8, lines.length * 4.3 + 4);
      ensureSpace(blockHeight + 3);
      doc.setDrawColor(197, 211, 222);
      doc.setFillColor(255, 255, 255);
      doc.rect(leftMargin, y, contentWidth, blockHeight, 'FD');
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8.5);
      doc.setTextColor(20, 35, 55);
      doc.text(lines, leftMargin + 2, y + 4.5);
      y += blockHeight + 4;
    };

    drawOfficialHeader();

    // Intro Carta Oficial
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9);
    doc.setTextColor(11, 37, 69);
    doc.text(
      `Bucaramanga, ${proposal.submittedAt ? proposal.submittedAt.slice(0, 10) : new Date().toISOString().slice(0, 10)} | Version de envio: V${proposal.revisionCount}`,
      leftMargin,
      y
    );
    y += 5;
    doc.text('SENORES: Comite Tecnico Cientifico Instituto MASIRA-UDES', leftMargin, y);
    y += 5;
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(8.3);
    const propLines = doc.splitTextToSize(
      'Proposito: Obtener concepto de viabilidad e interes del Comite Tecnico Cientifico del Instituto MASIRA - UDES de la Facultad de Ciencias Medicas y de la Salud, con el fin de continuar el tramite de formalizacion ante la Vicerrectoria de Investigaciones del proyecto a someter.',
      contentWidth
    );
    doc.text(propLines, leftMargin, y);
    y += propLines.length * 4.2 + 3;

    // 1. IDENTIFICACIÓN DEL PROYECTO
    writeSectionHeading('1. IDENTIFICACION DEL PROYECTO');
    writeSubHeading('1.1. Informacion general');
    writeKeyValueRow('Titulo del Proyecto:', proposal.title);
    writeKeyValueRow('Programa o Unidad Academica:', proposal.academicProgram);
    writeKeyValueRow('Campus:', proposal.campus);
    writeKeyValueRow('Grupo de respaldo:', proposal.backingGroup);
    writeKeyValueRow('Lider del grupo:', proposal.groupLeader);
    writeKeyValueRow('Linea de investigacion:', proposal.researchLine);
    writeKeyValueRow('Investigador principal:', proposal.principalInvestigatorName);
    writeKeyValueRow('Correo investigador principal:', proposal.principalInvestigatorEmail);
    writeKeyValueRow('Nombre Entidad Aliada:', proposal.alliedEntityName);
    writeKeyValueRow('Lugar de Desarrollo:', proposal.developmentLocation);
    writeKeyValueRow('Nombre de la convocatoria:', proposal.callName);
    writeKeyValueRow('Tipo de convocatoria:', proposal.callType);
    writeKeyValueRow('Fecha limite de convocatoria:', proposal.callDeadline);
    y += 4;

    // 1.2 Equipo de Trabajo
    writeSubHeading('1.2. Equipo de trabajo');
    proposal.workTeam.forEach((member, idx) => {
      writeKeyValueRow(
        `${idx + 1}. ${member.nombre} (${member.rol})`,
        `Entidad: ${member.entidad} | Responsabilidades: ${member.responsabilidades}`
      );
    });
    y += 4;

    // 2. RESUMEN EJECUTIVO
    writeSectionHeading('2. RESUMEN EJECUTIVO');
    writeNarrativeBlock('2.1. Planteamiento del problema y justificacion:', proposal.problemAndJustification);
    writeNarrativeBlock('2.1. Objetivo General:', proposal.generalObjective);
    writeNarrativeBlock('2.2. Objetivos Especificos:', proposal.specificObjectives);
    writeSubHeading('2.3. Metodologia');
    writeNarrativeBlock('2.3.1. Diseno metodologico:', proposal.methodologyDesign);
    writeNarrativeBlock('2.3.2. Ambito del estudio:', proposal.studySetting);
    writeNarrativeBlock('2.3.3. Participantes y muestreo:', proposal.participantsAndSampling);
    writeNarrativeBlock('2.3.4. Criterios de elegibilidad:', proposal.eligibilityCriteria);
    writeNarrativeBlock('2.3.5. Reclutamiento:', proposal.recruitmentPlan);
    writeNarrativeBlock('2.3.6. Tecnicas de recoleccion de informacion:', proposal.dataCollectionTechniques);
    writeNarrativeBlock('2.3.7. Procedimientos:', proposal.proceduresDescription);
    writeNarrativeBlock('2.3.8. Analisis de Datos:', proposal.dataAnalysisPlan);
    writeNarrativeBlock('2.3.9. Consideraciones eticas:', proposal.ethicalConsiderations);
    writeNarrativeBlock('2.4. Resultados y Productos Esperados:', proposal.expectedResults);

    // 3. POSIBLES ALIANZAS Y TRABAJOS EN RED
    writeSectionHeading('3. POSIBLES ALIANZAS Y TRABAJOS EN RED');
    writeNarrativeBlock('Red de cooperacion y alianzas cientificas:', proposal.possibleAlliances);

    // 4. ANÁLISIS DE RIESGOS DE EJECUCIÓN
    writeSectionHeading('4. ANALISIS DE RIESGOS DE EJECUCION');
    proposal.riskMatrix.forEach((risk) => {
      writeKeyValueRow(
        `Riesgo ${risk.tipoRiesgo}`,
        `Descripcion: ${risk.descripcion} | Probabilidad: ${risk.probabilidad} | Impacto: ${risk.impacto} | Mitigacion: ${risk.medidasMitigacion}`
      );
    });
    y += 4;

    // 5. PRESUPUESTO (RESUMEN)
    writeSectionHeading('5. PRESUPUESTO (RESUMEN POR RUBROS)');
    proposal.budgetItems.forEach((rubro) => {
      writeKeyValueRow(
        `${rubro.item}. ${rubro.rubro}`,
        `UDES Esp: ${this.formatCurrency(rubro.contrapartidaUdesEspecie)} | UDES Efec: ${this.formatCurrency(rubro.contrapartidaUdesEfectivo)} | Aliado Esp: ${this.formatCurrency(rubro.aliadoEspecie)} | Aliado Efec: ${this.formatCurrency(rubro.aliadoEfectivo)} | Convocatoria: ${this.formatCurrency(rubro.entidadConvocatoriaEfectivo)} | TOTAL: ${this.formatCurrency(rubro.total)}`
      );
    });
    writeKeyValueRow('TOTAL GENERAL DEL PROYECTO:', this.formatCurrency(proposal.budgetTotal));
    y += 4;

    // 6. CRONOGRAMA DE ACTIVIDADES
    writeSectionHeading('6. CRONOGRAMA DE ACTIVIDADES (12 TRIMESTRES - 3 ANOS)');
    proposal.scheduleItems.forEach((row, index) => {
      const activeQ = row.trimestres
        .map((active, i) => (active ? `T${i + 1}` : null))
        .filter(Boolean)
        .join(', ');
      writeKeyValueRow(
        `Actividad ${index + 1}: ${row.objetivo}`,
        `${row.actividades} | Trimestres programados: [${activeQ || 'Ninguno'}]`
      );
    });
    y += 4;

    // DOCUMENTACIÓN ADICIONAL ADJUNTA
    writeSectionHeading('DOCUMENTACION ADICIONAL DE SUSTENTO CARGADA');
    if (!proposal.attachments.length) {
      writeKeyValueRow('Archivos anexos:', 'No se registran anexos adicionales.');
    } else {
      proposal.attachments.forEach((att, idx) => {
        writeKeyValueRow(
          `Anexo ${idx + 1}: ${att.fileName}`,
          `Categoria: ${att.category} | Tipo: ${att.mimeType} | Tamano: ${(att.fileSizeBytes / 1024).toFixed(1)} KB`
        );
      });
    }
    y += 5;

    // APÉNDICES HISTÓRICOS DE VERSIONES ENVIADAS (VERSIÓN 1, VERSIÓN 2, ...)
    if (proposal.versionHistory && proposal.versionHistory.length > 0) {
      writeSectionHeading('APENDICES DE VERSIONES ENVIADAS DE LA PROPUESTA (HISTORIAL COMPLETO)');
      proposal.versionHistory.forEach((ver) => {
        writeSectionHeading(`APENDICE - VERSION ${ver.versionNumber} (Enviado: ${ver.submittedAt})`);
        writeKeyValueRow(`Version ${ver.versionNumber} - Titulo:`, ver.title);
        writeKeyValueRow(`Version ${ver.versionNumber} - Programa y Campus:`, `${ver.academicProgram} (${ver.campus})`);
        writeKeyValueRow(`Version ${ver.versionNumber} - Grupo y Linea:`, `${ver.backingGroup} | ${ver.researchLine}`);
        writeKeyValueRow(
          `Version ${ver.versionNumber} - Investigador Principal:`,
          `${ver.principalInvestigatorName} (${ver.principalInvestigatorEmail})`
        );
        writeKeyValueRow(
          `Version ${ver.versionNumber} - Convocatoria y Aliado:`,
          `${ver.callName} (${ver.callType}) | Aliado: ${ver.alliedEntityName || 'N/A'}`
        );
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.1 Problema y justificacion:`, ver.problemAndJustification);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.1 Objetivo General:`, ver.generalObjective);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.2 Objetivos Especificos:`, ver.specificObjectives);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.1 Diseno metodologico:`, ver.methodologyDesign);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.2 Ambito del estudio:`, ver.studySetting);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.3 Participantes y muestreo:`, ver.participantsAndSampling);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.4 Criterios de elegibilidad:`, ver.eligibilityCriteria);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.5 Reclutamiento:`, ver.recruitmentPlan);
        writeNarrativeBlock(
          `Version ${ver.versionNumber} - 2.3.6 Tecnicas de recoleccion:`,
          ver.dataCollectionTechniques
        );
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.7 Procedimientos:`, ver.proceduresDescription);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.8 Analisis de Datos:`, ver.dataAnalysisPlan);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.3.9 Consideraciones eticas:`, ver.ethicalConsiderations);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 2.4 Resultados esperados:`, ver.expectedResults);
        writeNarrativeBlock(`Version ${ver.versionNumber} - 3. Posibles Alianzas:`, ver.possibleAlliances);
        writeKeyValueRow(
          `Version ${ver.versionNumber} - 5. Presupuesto Total:`,
          this.formatCurrency(ver.budgetTotal)
        );
        y += 4;
      });
    }

    // CONTROL DE CAMBIOS OFICIAL (Páginas 4-5 de CIM-FT-002-BUC)
    writeSectionHeading('CONTROL DE CAMBIOS (CIM-FT-002-BUC VERSION 00 - 19/05/2026)');
    writeKeyValueRow(
      'Aprobacion Institucional:',
      'Dr. Patricio Lopez Jaramillo (Rector, Director Cientifico) | Dr. William Reyes Serpa (Decano Facultad de Ciencias de la Salud)'
    );
    writeKeyValueRow(
      'Elaboracion y Revision:',
      'Arq. Hernan Villa-Roel Ramirez (Director Ejecutivo) | Dr. Jose Patricio Lopez Lopez (Director Unidad de Diseno y Desarrollo de Proyectos) | Dra. Mabel Margoth Reyes (Coordinadora Administrativa y de Gestion del Conocimiento) | Wilneider Plata Arguello (Coordinador Nacional de Gestion Documental)'
    );

    doc.save(`${proposal.code}_CIM-FT-002-BUC_V${proposal.revisionCount}.pdf`);
  }

  public downloadCtcConceptPdf(proposal: ResearchProposal): void {
    const doc = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'letter'
    });

    const leftMargin = 16;
    const contentWidth = 215.9 - leftMargin * 2;
    let y = 18;

    doc.setFillColor(11, 37, 69);
    doc.rect(leftMargin, 12, contentWidth, 20, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(11);
    doc.setTextColor(255, 255, 255);
    doc.text('INSTITUTO DE INVESTIGACION MASIRA · UNIVERSIDAD DE SANTANDER (UDES)', leftMargin + 4, 19);
    doc.setFontSize(9.5);
    doc.text('ACTA Y CONCEPTO OFICIAL DEL COMITE TECNICO CIENTIFICO (CTC)', leftMargin + 4, 26);

    y = 40;
    doc.setTextColor(11, 37, 69);
    doc.setFontSize(10);
    doc.text(`Radicado de Propuesta: ${proposal.code} (Version evaluada: V${proposal.revisionCount})`, leftMargin, y);
    y += 6;
    const titleLines = doc.splitTextToSize(`Titulo del Proyecto: ${proposal.title}`, contentWidth);
    doc.text(titleLines, leftMargin, y);
    y += titleLines.length * 4.8 + 2;

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(9);
    doc.text(
      `Investigador Principal: ${proposal.principalInvestigatorName} (${proposal.principalInvestigatorEmail})`,
      leftMargin,
      y
    );
    y += 5;
    doc.text(`Programa / Unidad: ${proposal.academicProgram} · Grupo: ${proposal.backingGroup}`, leftMargin, y);
    y += 8;

    const conceptLabel = proposal.ctcConcept || 'EN EVALUACION DEL PLENO';
    doc.setFillColor(240, 253, 250);
    doc.setDrawColor(15, 118, 110);
    doc.rect(leftMargin, y, contentWidth, 12, 'FD');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10.5);
    doc.setTextColor(15, 118, 110);
    doc.text(`CONCEPTO EMITIDO POR EL COMITE TECNICO CIENTIFICO: ${conceptLabel}`, leftMargin + 4, y + 7.5);
    y += 18;

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(9.5);
    doc.setTextColor(11, 37, 69);
    doc.text('OBSERVACIONES PUNTO A PUNTO Y TRAZABILIDAD DE REVISION:', leftMargin, y);
    y += 6;

    proposal.reviews.forEach((rev) => {
      if (y > 245) {
        doc.addPage();
        y = 20;
      }
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(8.8);
      doc.setTextColor(11, 37, 69);
      doc.text(
        `[${rev.stage}] Decision: ${rev.decision} | Responsable: ${rev.reviewerName} | Fecha: ${rev.createdAt.slice(0, 10)}`,
        leftMargin,
        y
      );
      y += 4.5;
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8.4);
      const summaryLines = doc.splitTextToSize(`Sintesis: ${rev.generalSummary}`, contentWidth);
      doc.text(summaryLines, leftMargin, y);
      y += summaryLines.length * 4.2 + 2;

      rev.pointObservations.forEach((obs) => {
        const obsLines = doc.splitTextToSize(
          `• Numeral ${obs.itemCode} (${obs.itemLabel}): ${obs.observation} [${obs.resolved ? 'AJUSTE APLICADO' : 'PENDIENTE'}]`,
          contentWidth - 6
        );
        doc.text(obsLines, leftMargin + 4, y);
        y += obsLines.length * 4.1 + 1.5;
      });
      y += 3;
    });

    y += 4;
    if (y > 220) {
      doc.addPage();
      y = 20;
    }

    // Requerimiento 5: Si el concepto es FAVORABLE_CON_OBSERVACIONES y el investigador aún no ha subsanado,
    // se genera el reporte SIN la aprobación firmada de los miembros del CTC.
    if (proposal.ctcConcept === 'FAVORABLE_CON_OBSERVACIONES' && !proposal.ctcModificationsCleared) {
      doc.setFillColor(254, 243, 199);
      doc.setDrawColor(180, 83, 9);
      doc.rect(leftMargin, y, contentWidth, 26, 'FD');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9.5);
      doc.setTextColor(120, 53, 15);
      doc.text(
        'REPORTE EMITIDO SIN APROBACION DEFINITIVA DE LOS MIEMBROS DEL COMITE TECNICO CIENTIFICO',
        leftMargin + 4,
        y + 6.5
      );
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8.5);
      const notice = doc.splitTextToSize(
        'De conformidad con los lineamientos del Instituto MASIRA - UDES, esta propuesta obtuvo CONCEPTO FAVORABLE CON MODIFICACIONES / OBSERVACIONES. El presente reporte se expide sin la firma de aprobacion de los miembros del Comite Tecnico Cientifico hasta tanto el Investigador Principal realice los ajustes necesarios o demandados y las aclaraciones solicitadas punto a punto.',
        contentWidth - 8
      );
      doc.text(notice, leftMargin + 4, y + 12);
    } else {
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9.5);
      doc.setTextColor(11, 37, 69);
      doc.text(
        'APROBACION Y FIRMA DE MIEMBROS DEL COMITE TECNICO CIENTIFICO (TOKENS DE UN SOLO USO):',
        leftMargin,
        y
      );
      y += 6;
      proposal.signatureTokens.forEach((tok) => {
        doc.setDrawColor(197, 211, 222);
        doc.setFillColor(255, 255, 255);
        doc.rect(leftMargin, y, contentWidth, 12, 'FD');
        doc.setFont('helvetica', 'bold');
        doc.setFontSize(8.5);
        doc.setTextColor(11, 37, 69);
        doc.text(`${tok.memberName} — ${tok.memberPosition}`, leftMargin + 3, y + 4.8);
        doc.setFont('courier', 'normal');
        doc.setFontSize(7.8);
        if (tok.isUsed) {
          doc.setTextColor(15, 118, 110);
          doc.text(
            `FIRMADO CON TOKEN UNICO: ${tok.singleUseToken} | Fecha: ${tok.usedAt?.slice(0, 16).replace('T', ' ')} | Hash: ${(tok.signatureHash || '').slice(0, 24)}...`,
            leftMargin + 3,
            y + 9.5
          );
        } else {
          doc.setTextColor(180, 83, 9);
          doc.text('PENDIENTE DE FIRMA CON TOKEN DE UNA SOLA UTILIZACION', leftMargin + 3, y + 9.5);
        }
        y += 14;
      });
    }

    doc.save(`${proposal.code}_Concepto_CTC_MASIRA.pdf`);
  }

  public downloadCustomReportPdf(
    proposals: ResearchProposal[],
    selectedFields: ReportFieldOption[],
    extractor: (p: ResearchProposal, key: string) => string
  ): void {
    const doc = new jsPDF({
      orientation: 'landscape',
      unit: 'mm',
      format: 'letter'
    });

    doc.setFillColor(11, 37, 69);
    doc.rect(14, 12, 251, 16, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(11);
    doc.setTextColor(255, 255, 255);
    doc.text(
      'INSTITUTO MASIRA · UDES — LISTADO PERSONALIZADO DE PROYECTOS (SECRETARIA TECNICA CTC)',
      18,
      21.5
    );

    let y = 35;
    proposals.forEach((p, idx) => {
      if (y > 185) {
        doc.addPage();
        y = 20;
      }
      doc.setFillColor(246, 248, 247);
      doc.setDrawColor(11, 37, 69);
      doc.rect(14, y, 251, 7, 'FD');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9);
      doc.setTextColor(11, 37, 69);
      doc.text(`${idx + 1}. Proyecto ${p.code} — ${p.title}`, 17, y + 4.8);
      y += 9;

      selectedFields.forEach((field) => {
        if (y > 195) {
          doc.addPage();
          y = 20;
        }
        const val = extractor(p, field.key);
        const lines = doc.splitTextToSize(`${field.label}: ${val}`, 245);
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(8.3);
        doc.setTextColor(25, 40, 60);
        doc.text(lines, 17, y);
        y += lines.length * 4.1 + 1;
      });
      y += 4;
    });

    doc.save('Listado_Proyectos_CTC_MASIRA_UDES.pdf');
  }
}
