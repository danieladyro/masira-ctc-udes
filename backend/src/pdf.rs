use crate::models::{CtcSignatureToken, Proposal, ProposalAttachment, ProposalReview};
use printpdf::*;
use std::io::BufWriter;

fn wrap_lines(text: &str, max_chars: usize) -> Vec<String> {
    let mut lines = Vec::new();
    for raw_line in text.lines() {
        if raw_line.trim().is_empty() {
            lines.push(String::new());
            continue;
        }
        let mut current = String::new();
        for word in raw_line.split_whitespace() {
            if current.len() + word.len() + 1 > max_chars && !current.is_empty() {
                lines.push(current.clone());
                current.clear();
            }
            if !current.is_empty() {
                current.push(' ');
            }
            current.push_str(word);
        }
        if !current.is_empty() {
            lines.push(current);
        }
    }
    if lines.is_empty() {
        lines.push("Sin registro.".to_string());
    }
    lines
}

pub fn generate_proposal_pdf(
    proposal: &Proposal,
    attachments: &[ProposalAttachment],
) -> Result<Vec<u8>, String> {
    let (doc, page1, layer1) = PdfDocument::new(
        format!("CIM-FT-002-BUC - {}", proposal.code),
        Mm(215.9),
        Mm(279.4),
        "Capa Principal",
    );
    let font_regular = doc
        .add_builtin_font(BuiltinFont::Helvetica)
        .map_err(|e| e.to_string())?;
    let font_bold = doc
        .add_builtin_font(BuiltinFont::HelveticaBold)
        .map_err(|e| e.to_string())?;

    let mut current_layer = doc.get_page(page1).get_layer(layer1);
    let mut y_mm = 262.0_f32;

    let write_line = |text: &str, size: f32, bold: bool, doc: &PdfDocumentReference, layer: &mut PdfLayerReference, y: &mut f32| {
        if *y < 22.0 {
            let (new_page, new_layer) = doc.add_page(Mm(215.9), Mm(279.4), "Continuacion");
            *layer = doc.get_page(new_page).get_layer(new_layer);
            *y = 262.0;
            layer.use_text(
                "Centro de Investigacion MASIRA - UDES | SOMETIMIENTO INICIAL CIM-FT-002-BUC | Version: 00",
                8.5,
                Mm(18.0),
                Mm(*y),
                &font_bold,
            );
            *y -= 8.0;
        }
        let chosen_font = if bold { &font_bold } else { &font_regular };
        layer.use_text(text, size, Mm(18.0), Mm(*y), chosen_font);
        *y -= (size * 0.45) + 2.2;
    };

    // Encabezado Institucional CIM-FT-002-BUC
    write_line(
        "UNIVERSIDAD DE SANTANDER (UDES) - CENTRO DE INVESTIGACION MASIRA",
        11.5,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    write_line(
        "FORMATO OFICIAL: SOMETIMIENTO INICIAL | CODIGO: CIM-FT-002-BUC | VERSION: 00",
        10.0,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    write_line(
        &format!(
            "Radicado: {} | Revision: V{} | Estado: {} | Bucaramanga",
            proposal.code, proposal.revision_count, proposal.status
        ),
        9.0,
        false,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    y_mm -= 3.0;
    write_line(
        "Proposito: Obtener concepto de viabilidad e interes del Comite Tecnico Cientifico del Instituto MASIRA - UDES",
        8.5,
        false,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    y_mm -= 4.0;

    // 1. IDENTIFICACIÓN DEL PROYECTO
    write_line("1. IDENTIFICACION DEL PROYECTO", 11.0, true, &doc, &mut current_layer, &mut y_mm);
    write_line("1.1. Informacion general", 10.0, true, &doc, &mut current_layer, &mut y_mm);

    let general_fields = vec![
        ("Titulo del Proyecto", proposal.title.as_str()),
        ("Programa o Unidad Academica", proposal.academic_program.as_str()),
        ("Campus", proposal.campus.as_str()),
        ("Grupo de respaldo", proposal.backing_group.as_str()),
        ("Lider del grupo", proposal.group_leader.as_str()),
        ("Linea de investigacion", proposal.research_line.as_str()),
        ("Investigador principal", proposal.principal_investigator_name.as_str()),
        ("Correo electronico investigador principal", proposal.principal_investigator_email.as_str()),
        ("Nombre Entidad Aliada", proposal.allied_entity_name.as_str()),
        ("Lugar de Desarrollo", proposal.development_location.as_str()),
        ("Nombre de la convocatoria", proposal.call_name.as_str()),
        ("Tipo de convocatoria", proposal.call_type.as_str()),
    ];
    for (label, val) in general_fields {
        for line in wrap_lines(&format!("{}: {}", label, val), 92) {
            write_line(&line, 9.0, false, &doc, &mut current_layer, &mut y_mm);
        }
    }
    let deadline_str = proposal
        .call_deadline
        .map(|d| d.to_string())
        .unwrap_or_else(|| "No especificada".to_string());
    write_line(
        &format!("Fecha limite de la convocatoria: {}", deadline_str),
        9.0,
        false,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    y_mm -= 3.0;

    // 1.2 Equipo de Trabajo
    write_line("1.2. Equipo de trabajo", 10.0, true, &doc, &mut current_layer, &mut y_mm);
    for member in proposal.work_team.0.iter() {
        let row = format!(
            "- {} | Rol: {} | Entidad: {} | Resp.: {}",
            member.nombre, member.rol, member.entidad, member.responsabilidades
        );
        for line in wrap_lines(&row, 92) {
            write_line(&line, 8.8, false, &doc, &mut current_layer, &mut y_mm);
        }
    }
    y_mm -= 3.0;

    // 2. RESUMEN EJECUTIVO
    write_line("2. RESUMEN EJECUTIVO", 11.0, true, &doc, &mut current_layer, &mut y_mm);
    let narrative_sections = vec![
        ("2.1. Planteamiento del problema y justificacion", &proposal.problem_and_justification),
        ("2.1. Objetivo General", &proposal.general_objective),
        ("2.2. Objetivos Especificos", &proposal.specific_objectives),
        ("2.3.1. Diseno metodologico", &proposal.methodology_design),
        ("2.3.2. Ambito del estudio", &proposal.study_setting),
        ("2.3.3. Participantes y muestreo", &proposal.participants_and_sampling),
        ("2.3.4. Criterios de elegibilidad", &proposal.eligibility_criteria),
        ("2.3.5. Reclutamiento", &proposal.recruitment_plan),
        ("2.3.6. Tecnicas de recoleccion de informacion", &proposal.data_collection_techniques),
        ("2.3.7. Procedimientos", &proposal.procedures_description),
        ("2.3.8. Analisis de Datos", &proposal.data_analysis_plan),
        ("2.3.9. Consideraciones eticas", &proposal.ethical_considerations),
        ("2.4. Resultados y Productos Esperados", &proposal.expected_results),
        ("3. Posibles Alianzas y Trabajos en Red", &proposal.possible_alliances),
    ];

    for (heading, content) in narrative_sections {
        write_line(heading, 9.5, true, &doc, &mut current_layer, &mut y_mm);
        for line in wrap_lines(content, 94) {
            write_line(&line, 8.8, false, &doc, &mut current_layer, &mut y_mm);
        }
        y_mm -= 2.0;
    }

    // 4. ANÁLISIS DE RIESGOS DE EJECUCIÓN
    write_line("4. ANALISIS DE RIESGOS DE EJECUCION", 10.5, true, &doc, &mut current_layer, &mut y_mm);
    for risk in proposal.risk_matrix.0.iter() {
        let line_text = format!(
            "[{}] Probabilidad: {} | Impacto: {} | Desc: {} | Mitigacion: {}",
            risk.tipo_riesgo, risk.probabilidad, risk.impacto, risk.descripcion, risk.medidas_mitigacion
        );
        for line in wrap_lines(&line_text, 92) {
            write_line(&line, 8.5, false, &doc, &mut current_layer, &mut y_mm);
        }
    }
    y_mm -= 3.0;

    // 5. PRESUPUESTO
    write_line("5. PRESUPUESTO (RESUMEN EN COP)", 10.5, true, &doc, &mut current_layer, &mut y_mm);
    for item in proposal.budget_items.0.iter() {
        let row = format!(
            "{}. {} | UDES Esp: ${} | UDES Efec: ${} | Aliado Esp: ${} | Aliado Efec: ${} | Conv: ${} | TOTAL: ${}",
            item.item,
            item.rubro,
            item.contrapartida_udes_especie,
            item.contrapartida_udes_efectivo,
            item.aliado_especie,
            item.aliado_efectivo,
            item.entidad_convocatoria_efectivo,
            item.total
        );
        for line in wrap_lines(&row, 94) {
            write_line(&line, 8.3, false, &doc, &mut current_layer, &mut y_mm);
        }
    }
    write_line(
        &format!("TOTAL PRESUPUESTO PROYECTO: $ {} COP", proposal.budget_total),
        9.5,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    y_mm -= 3.0;

    // 6. CRONOGRAMA DE ACTIVIDADES
    write_line("6. CRONOGRAMA DE ACTIVIDADES (12 TRIMESTRES - 3 ANOS)", 10.5, true, &doc, &mut current_layer, &mut y_mm);
    for sched in proposal.schedule_items.0.iter() {
        let active_quarters: Vec<String> = sched
            .trimestres
            .iter()
            .enumerate()
            .filter_map(|(idx, &active)| if active { Some(format!("T{}", idx + 1)) } else { None })
            .collect();
        let line_text = format!(
            "Objetivo: {} | Actividades: {} | Trimestres: [{}]",
            sched.objetivo,
            sched.actividades,
            active_quarters.join(", ")
        );
        for line in wrap_lines(&line_text, 92) {
            write_line(&line, 8.5, false, &doc, &mut current_layer, &mut y_mm);
        }
    }
    y_mm -= 3.0;

    // DOCUMENTACIÓN ADICIONAL ADJUNTA
    write_line("DOCUMENTACION ADICIONAL DE SUSTENTO", 10.0, true, &doc, &mut current_layer, &mut y_mm);
    if attachments.is_empty() {
        write_line("Sin anexos cargados.", 8.5, false, &doc, &mut current_layer, &mut y_mm);
    } else {
        for att in attachments {
            write_line(
                &format!("- {} ({}) - {} bytes", att.file_name, att.category, att.file_size_bytes),
                8.5,
                false,
                &doc,
                &mut current_layer,
                &mut y_mm,
            );
        }
    }
    y_mm -= 4.0;

    // APÉNDICES HISTÓRICOS DE VERSIONES ENVIADAS (VERSIÓN 1, VERSIÓN 2, ...)
    if !proposal.version_history.0.is_empty() {
        write_line(
            "APENDICES HISTORICOS DE ENVIOS DE LA PROPUESTA (TRAZABILIDAD DE VERSIONES)",
            11.0,
            true,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        for snap in proposal.version_history.0.iter() {
            y_mm -= 2.0;
            write_line(
                &format!(
                    "==============================================================================="
                ),
                8.5,
                true,
                &doc,
                &mut current_layer,
                &mut y_mm,
            );
            write_line(
                &format!(
                    "APENDICE - {} (VERSION {}) | Radicado: {} | Fecha de Envio: {}",
                    snap.version_label.to_uppercase(),
                    snap.version_number,
                    proposal.code,
                    snap.submitted_at
                ),
                10.0,
                true,
                &doc,
                &mut current_layer,
                &mut y_mm,
            );
            let snap_fields = vec![
                ("1.1 Titulo del Proyecto", snap.title.as_str()),
                ("1.1 Programa / Unidad", snap.academic_program.as_str()),
                ("1.1 Grupo de respaldo", snap.backing_group.as_str()),
                ("1.1 Linea de investigacion", snap.research_line.as_str()),
                ("1.1 Investigador Principal", snap.principal_investigator_name.as_str()),
                ("2.1 Problema y justificacion", snap.problem_and_justification.as_str()),
                ("2.1 Objetivo General", snap.general_objective.as_str()),
                ("2.2 Objetivos Especificos", snap.specific_objectives.as_str()),
                ("2.3.1 Diseno metodologico", snap.methodology_design.as_str()),
                ("2.3.2 Ambito del estudio", snap.study_setting.as_str()),
                ("2.3.3 Participantes y muestreo", snap.participants_and_sampling.as_str()),
                ("2.3.4 Criterios de elegibilidad", snap.eligibility_criteria.as_str()),
                ("2.3.5 Reclutamiento", snap.recruitment_plan.as_str()),
                ("2.3.6 Recoleccion de informacion", snap.data_collection_techniques.as_str()),
                ("2.3.7 Procedimientos", snap.procedures_description.as_str()),
                ("2.3.8 Analisis de Datos", snap.data_analysis_plan.as_str()),
                ("2.3.9 Consideraciones eticas", snap.ethical_considerations.as_str()),
                ("2.4 Resultados esperados", snap.expected_results.as_str()),
                ("3. Posibles Alianzas", snap.possible_alliances.as_str()),
            ];
            for (lbl, txt) in snap_fields {
                for line in wrap_lines(&format!("{}: {}", lbl, txt), 92) {
                    write_line(&line, 8.4, false, &doc, &mut current_layer, &mut y_mm);
                }
            }
            write_line(
                &format!("5. Presupuesto Total ({}): $ {} COP", snap.version_label, snap.budget_total),
                8.8,
                true,
                &doc,
                &mut current_layer,
                &mut y_mm,
            );
            y_mm -= 2.0;
        }
    }

    // CONTROL DE CAMBIOS OFICIAL
    write_line(
        "CONTROL DE CAMBIOS (VERSION 00 - FECHA APROBACION: 19/05/2026)",
        9.5,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    write_line(
        "Responsables: Dr. Patricio Lopez Jaramillo (Rector, Director Cientifico) | Dr. William Reyes Serpa (Decano Ciencias de la Salud)",
        8.0,
        false,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    write_line(
        "Arq. Hernan Villa-Roel Ramirez | Dr. Jose Patricio Lopez Lopez | Dra. Mabel Margoth Reyes | Wilneider Plata Arguello",
        8.0,
        false,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );

    let mut buffer = BufWriter::new(Vec::new());
    doc.save(&mut buffer).map_err(|e| e.to_string())?;
    buffer.into_inner().map_err(|e| e.to_string())
}

pub fn generate_ctc_concept_pdf(
    proposal: &Proposal,
    reviews: &[ProposalReview],
    tokens: &[CtcSignatureToken],
) -> Result<Vec<u8>, String> {
    let (doc, page1, layer1) = PdfDocument::new(
        format!("Concepto CTC MASIRA - {}", proposal.code),
        Mm(215.9),
        Mm(279.4),
        "Acta Concepto CTC",
    );
    let font_regular = doc
        .add_builtin_font(BuiltinFont::Helvetica)
        .map_err(|e| e.to_string())?;
    let font_bold = doc
        .add_builtin_font(BuiltinFont::HelveticaBold)
        .map_err(|e| e.to_string())?;

    let mut current_layer = doc.get_page(page1).get_layer(layer1);
    let mut y_mm = 260.0_f32;

    let write_line = |text: &str, size: f32, bold: bool, doc: &PdfDocumentReference, layer: &mut PdfLayerReference, y: &mut f32| {
        if *y < 22.0 {
            let (new_page, new_layer) = doc.add_page(Mm(215.9), Mm(279.4), "Continuacion Concepto");
            *layer = doc.get_page(new_page).get_layer(new_layer);
            *y = 260.0;
        }
        let chosen_font = if bold { &font_bold } else { &font_regular };
        layer.use_text(text, size, Mm(18.0), Mm(*y), chosen_font);
        *y -= (size * 0.45) + 2.5;
    };

    write_line(
        "INSTITUTO DE INVESTIGACION MASIRA - UNIVERSIDAD DE SANTANDER (UDES)",
        11.5,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    write_line(
        "CONCEPTO OFICIAL DEL PLENO DEL COMITE TECNico CIENTIFICO",
        10.5,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    y_mm -= 2.0;
    write_line(
        &format!("Codigo del Proyecto: {} (Revision V{})", proposal.code, proposal.revision_count),
        9.5,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    for line in wrap_lines(&format!("Titulo: {}", proposal.title), 90) {
        write_line(&line, 9.0, false, &doc, &mut current_layer, &mut y_mm);
    }
    write_line(
        &format!("Investigador Principal: {} ({})", proposal.principal_investigator_name, proposal.principal_investigator_email),
        9.0,
        false,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    let concept_str = proposal
        .ctc_concept
        .as_deref()
        .unwrap_or("EN EVALUACION DE COMITE");
    write_line(
        &format!("DECISION / CONCEPTO DEL PLENO CTC: {}", concept_str),
        11.0,
        true,
        &doc,
        &mut current_layer,
        &mut y_mm,
    );
    y_mm -= 3.0;

    write_line("OBSERVACIONES PUNTO A PUNTO DE LA PROPUESTA:", 10.0, true, &doc, &mut current_layer, &mut y_mm);
    for rev in reviews {
        write_line(
            &format!("[{}] Decision: {} | Revisor: {}", rev.stage, rev.decision, rev.reviewer_name),
            9.2,
            true,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        for line in wrap_lines(&rev.general_summary, 90) {
            write_line(&line, 8.8, false, &doc, &mut current_layer, &mut y_mm);
        }
        for obs in rev.point_observations.0.iter() {
            let obs_line = format!(
                "  * Numeral {} ({}): {} [{}]",
                obs.item_code,
                obs.item_label,
                obs.observation,
                if obs.resolved { "SUBSANADO" } else { "PENDIENTE" }
            );
            for line in wrap_lines(&obs_line, 90) {
                write_line(&line, 8.5, false, &doc, &mut current_layer, &mut y_mm);
            }
        }
        y_mm -= 2.0;
    }

    y_mm -= 4.0;
    // Regla del Requerimiento 5: Si el concepto es FAVORABLE_CON_OBSERVACIONES y no se han subsanado las modificaciones,
    // se genera el reporte SIN la aprobación firmada de los miembros hasta tanto el investigador haga los ajustes.
    if concept_str == "FAVORABLE_CON_OBSERVACIONES" && !proposal.ctc_modifications_cleared {
        write_line(
            "NOTA REGLAMENTARIA DE APROBACION DEL COMITE TECNICO CIENTIFICO:",
            10.0,
            true,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        write_line(
            "Este proyecto registra CONCEPTO FAVORABLE CON OBSERVACIONES / MODIFICACIONES.",
            9.0,
            true,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        write_line(
            "De acuerdo con el reglamento del CTC MASIRA-UDES, este reporte se expide SIN las firmas de aprobacion",
            8.8,
            false,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        write_line(
            "definitiva de los miembros del Comite Tecnico Cientifico hasta tanto el Investigador Principal realice",
            8.8,
            false,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        write_line(
            "los ajustes demandados o las aclaraciones solicitadas punto a punto en la plataforma.",
            8.8,
            false,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
    } else {
        write_line(
            "REGISTRO DE FIRMAS DE MIEMBROS DEL COMITE TECNICO CIENTIFICO (TOKENS DE UN SOLO USO):",
            10.0,
            true,
            &doc,
            &mut current_layer,
            &mut y_mm,
        );
        for t in tokens {
            let status_txt = if t.is_used {
                format!(
                    "FIRMADO CON TOKEN UNICO [{}] | Hash: {}",
                    t.single_use_token,
                    t.signature_hash.as_deref().unwrap_or("N/A")
                )
            } else {
                "PENDIENTE DE FIRMA CON TOKEN UNICO".to_string()
            };
            for line in wrap_lines(
                &format!("- {} ({}) -> {}", t.member_name, t.member_position, status_txt),
                90,
            ) {
                write_line(&line, 8.5, false, &doc, &mut current_layer, &mut y_mm);
            }
        }
    }

    let mut buffer = BufWriter::new(Vec::new());
    doc.save(&mut buffer).map_err(|e| e.to_string())?;
    buffer.into_inner().map_err(|e| e.to_string())
}
