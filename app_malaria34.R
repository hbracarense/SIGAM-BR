library("shiny")
library("shinydashboard")
library("shinyjs")
library("tidyverse")
library("shinycssloaders")
library("plotly")
library("RColorBrewer")
library("maptools")     
library("spdep")
library("cartography")    
library("tmap")
library("leaflet")
library("rgdal")
library("writexl")

#Carregamento das bases de dados------------------------------------------------
base_dados <- readRDS("base_dados.RDS")
base_ipa_uf <- readRDS("ipa_base.RDS")

#Variáveis globais--------------------------------------------------------------
color_vector <- c("rgb(0,0,139)", "rgb(136,45,23)", "rgb(85,105,47)", "rgb(238,173,14)", "rgb(102,205,0)", "rgb(105,105,105)", "rgb(199,21,133)", "rgb(95,158,160)" , "rgb(139,0,139)", "rgb(176,196,222)")

#Dicionário de tradução---------------------------------------------------------
translation <- list(
  "indicators_label" = list("pt" = "Indicadores:", "en" = "Indicators:"),
  "Valores absolutos" = list("pt" = "Valores absolutos", "en" = "Absolute values"),
  "Per capita" = list("pt" = "Per capita", "en" = "Per capita"),
  "Por notificação" = list("pt" = "Por notificação", "en" = "Per notification"),
  "epidemiological_tab_title" = list("pt" = "Informações epidemiológicas", "en" = "Epidemiological data"),
  "Ano" = list("pt" = "Ano:", "en" = "Year:"),
  "UF" = list("pt" = "UF:", "en" = "State:"),
  "Município" = list("pt" = "Município:", "en" = "Municipality:"),
  "Todos os municípios" = list("pt" = "Todos os municípios", "en" = "All municipalities"),
  "População" = list("pt" = "População", "en" = "Population"),
  "Notificações" = list("pt" = "Notificações", "en" = "Notifications"),
  "profile_notifications" = list("pt" = "Perfil de notificações", "en" = "Profile of notifications"),
  "notifications_nature" = list("pt" = c("Casos descartados", "Casos confirmados"), "en" = c("Discarted episodes", "Confirmed episodes")),
  "episodes_nature" = list("pt" = c("Casos não-complicados", "Casos severos"), "en" = c("Non-complicated episodes", "Severe episodes")),
  "casos" = list("pt" = "casos", "en" = "episodes"),
  "severity_episodes" = list("pt" = "Gravidade dos casos", "en" = "Severity of episodes"),
  "episodes_distribution_title" = list("pt" = "Distribuição dos casos", "en" = "Distribution of episodes"),
  "age_pyramid" = list("pt" = "Pirâmide etária", "en" = "Age pyramid"),
  "gender" = list("pt" = "Sexo", "en" = "Sex"),
  "age_group" = list("pt" = "Faixas etárias", "en" = "Age groups"),
  "Masculino" = list("pt" = "Masculino", "en" = "Male"),
  "Feminino" = list("pt" = "Feminino", "en" = "Female"),
  "Casos confirmados" = list("pt" = "Casos confirmados", "en" = "Confirmed episodes"),
  "genders" = list("pt" = c("Feminino", "Masculino"), "en" = c("Female", "Male")),
  "anos" = list("pt" = "anos", "en" = "years"),
  "Casos" = list("pt" = "Casos", "en" = "Episodes"),
  "LVC" = list("pt" = "Casos LVC", "en" = "Cure Slide Verification cases"),
  "Hospitalizações" = list("pt" = "Hospitalizações", "en" = "Hospitalizations"),
  "parasite_type" = list("pt" = "Tipo de parasita", "en" = "Parasite type"),
  "parasites" = list("pt" = c("Vivax", "Falciparum", "Outros"), "en" = c("Vivax", "Falciparum", "Other types")),
  "ano" = list("pt" = "Ano", "en" = "Year"),
  "parasite_axis" = list("pt" = "Casos por tipo de parasita", "en" = "Episodes per parasite type"),
  "Tendência" = list("pt" = "Tendência", "en" = "Yearly trend"),
  "Proporção anual" = list("pt" = "Proporção anual", "en" = "Annual proportion"),
  "visualization_label" = list("pt" = "Forma de visualização", "en" = "Visualization format"),
  "map_box" = list("pt" = "Distribuição geográfica da incidência", "en" = "Geographical distribution of incidence rate"),
  "IPA" = list("pt" = "IPA", "en" = "API"),
  "ipa_title" = list("pt" = "Índice Parasitário Anual", "en" = "Annual Parasite Index"),
  "ipa_graph" = list("pt" = "IPA -", "en" = "API -"),
  "label_map_very_low" = list("pt" = "Muito baixo (<1)", "en" = "Very low (<1)"),
  "label_map_low" = list("pt" = "Baixo (>=1 e <50)", "en" = "Low (>=1 and <50)"),
  "label_map_high" = list("pt" = "Alto (>=50)", "en" = "High (>=50)"),
  "diagnostic_treatment_tab_title_1" = list("pt" = "Despesas com diagnóstico e", "en" = "Diagnostic and treatment"),
  "diagnostic_treatment_tab_title_2" = list("pt" = "tratamento", "en" = "expenditures"),
  "diagnostic_tab_title" = list("pt" = "Despesas com diagnóstico", "en" = "Diagnostic expenditures"),
  "treatment_tab_title" = list("pt" = "Despesas com tratamento", "en" = "Treatment expenditures"),
  "episode_card_graph" = list("pt" = "/notificação", "en" = "/notification"),
  "tests_card_text" = list("pt" = "Despesas com exames", "en" = "Test expenditures"),
  "medicines_card_text" = list("pt" = "Despesas com medicamentos", "en" = "Pharmaceutical expenditures"),
  "hospitalization_cost_card_text" = list("pt" = "Despesas com hospitalizações", "en" = "Hospitalization expenditures"),
  "total_diagnostic_treatment_title" = list("pt" = "Despesas totais com diagnóstico e tratamento", "en" = "Total diagnostic and treatment expenditures"),
  "total_diagnostic_treatment_names" = list("pt" = c("Exames", "Medicamentos", "Hospitalizações"), "en" = c("Diagnostic tests", "Pharmaceuticals", "Hospitalizations")),
  "total_name" = list("pt" = "Despesas totais", "en" = "Total expenditures"),
  "total_diagnostic_treatment_yaxis" = list("pt" = "Despesas totais com diagnóstico e tratamento (R$)", "en" = "Total diagnostic and treatment expenditures (R$)"),
  "uf" = list("pt" = "Unidade Federativa", "en" = "State"),
  "city" = list("pt" = "Município", "en" = "Municipality"),
  "tests_title" = list("pt" = "Exames realizados", "en" = "Diagnostic tests performed"),
  "quantitative" = list("pt" = "Quantitativo", "en" = "Quantitative"),
  "expenditures" = list("pt" = "Despesas", "en" = "Expenditures"),
  "Exames totais" = list("pt" = "Exames totais", "en" = "All tests"),
  "Positivos" = list("pt" = "Positivos", "en" = "Positive"),
  "tests_type_title" = list("pt" = "Natureza dos exames", "en" = "Type of tests"),
  "Todos os tipos" = list("pt" = "Todos os tipos", "en" = "All types"),
  "Vivax" = list("pt" = "Vivax", "en" = "Vivax"),
  "Falciparum" = list("pt" = "Falciparum", "en" = "Falciparum"),
  "Outros" = list("pt" = "Outros", "en" = "Other types"),
  "tests_names" = list("pt" = c("Gota espessa", "Teste rápido"), "en" = c("Blood smear", "Rapid test")),
  "total_tests" = list("pt" = "Exames totais", "en" = "Total tests"),
  "tests_quantitative_yaxis" = list("pt" = "Exames diagnósticos", "en" = "Diagnostic tests"),
  "tests" = list("pt" = "exames", "en" = "tests"),
  "tests_expenditure_yaxis" = list("pt" = "Despesas com exames diagnósticos (R$)", "en" = "Diagnostic tests expenditures (R$)"),
  "medicines_title" = list("pt" = "Despesas com medicamentos", "en" = "Pharmaceutical expenditures"),
  "severe" = list("pt" = "Grave", "en" = "Severe"),
  "indicators" = list("pt" = "Indicadores", "en" = "Indicators"),
  "Por notificação (todos os esquemas)" = list("pt" = "Por notificação (todos os esquemas)", "en" = "Per notification (all schemes)"),
  "Por caso (esquema escolhido)" = list("pt" = "Por caso (esquema escolhido)", "en" = "Per episode (chosen scheme)"),
  "episode_card_scheme" = list("pt" = "/caso", "en" = "/episode"),
  "total_medicines_names" = list("pt" = c("Esquema 1", "Esquema 2", "Esquema 3", "Esquema 4", "Esquema 5"), "en" = c("Scheme 1", "Scheme 2", "Scheme 3", "Scheme 4", "Scheme 5")),
  "total_medicines_yaxis" = list("pt" = "Despesas totais com medicamentos (R$)", "en" = "Total pharmaceuticals expenditures (R$)"),
  "vivax_medicines_yaxis" = list("pt" = "Despesas com medicamentos - Esquema 1 (Vivax - R$)", "en" = "Pharmaceutical expenditures - Scheme 1 (Vivax - R$)"),
  "scheme_1" = list("pt" = "Esquema 1", "en" = "Scheme 1"),
  "falciparum_medicines_yaxis" = list("pt" = "Despesas com medicamentos - Esquema 2 (Falciparum - R$)", "en" = "Pharmaceutical expenditures - Scheme 2 (Falciparum - R$)"),
  "scheme_2" = list("pt" = "Esquema 2", "en" = "Scheme 2"),
  "others_medicines_yaxis" = list("pt" = "Despesas com medicamentos - Esquemas 3 e 4 (Outros - R$)", "en" = "Pharmaceutical expenditures - Schemes 3 and 4 (Others - R$)"),
  "scheme_3_4" = list("pt" = "Esquemas 3 e 4", "en" = "Schemes 3 and 4"),
  "severe_medicines_yaxis" = list("pt" = "Despesas com medicamentos - Esquema 5 (Grave - R$)", "en" = "Pharmaceutical expenditures - Scheme 5 (Severe - R$)"),
  "scheme_5" = list("pt" = "Esquema 5", "en" = "Scheme 5"),
  "length" = list("pt" = "Duração", "en" = "Length of stay"),
  "Média" = list("pt" = "Média", "en" = "Median"),
  "quantitative_hospitalization_yaxis" = list("pt" = "Quantidade de hospitalizações", "en" = "Number of hospitalizations"),
  "length_hospitalization_state_yaxis" = list("pt" = "Média estadual de duração de internações (dias)", "en" = "State average length of stay of hospitalization (days)"),
  "length_hospitalization_city_yaxis" = list("pt" = "Duração total de internação (dias)", "en" = "Total length of stay of hospitalizations (days)"),
  "length_hospitalization_average_city_yaxis" = list("pt" = "Duração média da internação (dias)", "en" = "Average length of stay of hospitalization (days)"),
  "days" = list("pt" = "dias", "en" = "days"),
  "expenditures_hospitalization_yaxis" = list("pt" = "Despesas com hospitalizações (R$)", "en" = "Hospitalization expenditures (R$)"),
  "surveillance_control_tab_title_1" = list("pt" = "Despesas com vigilância e", "en" = "Surveillance and control"),
  "surveillance_control_tab_title_2" = list("pt" = "controle", "en" = "expenditures"),
  "surveillance_tab_title" = list("pt" = "Despesas com vigilância", "en" = "Surveillance expenditures"),
  "control_tab_title" = list("pt" = "Despesas com controle", "en" = "Control expenditures"),
  "surveillance_card_subtitle" = list("pt" = "Despesas com vigilância em saúde", "en" = "Health surveillance expenditures"),
  "insecticide_card_subtitle" = list("pt" = "Despesas com inseticida", "en" = "Insecticide expenditures"),
  "screening_card_subtitle" = list("pt" = "Despesas com screening de bolsas de sangue", "en" = "Blood donor screening test expenditures"),
  "total_surveillance_control_title" = list("pt" = "Despesas totais com vigilância e controle", "en" = "Total surveillance and control expenditures"),
  "total_surveillance_control_names" = list("pt" = c("Vigilância", "Inseticida", "Mosquiteiro", "Screening"), "en" = c("Surveillance", "Insecticide", "Bed nets", "Sreening")),
  "total_surveillance_control_yaxis" = list("pt" = "Despesas totais com vigilância e controle (R$)", "en" = "Total surveillance and control expenditures (R$)"),
  "surveillance_box_title" = list("pt" = "Despesas com vigilância em saúde", "en" = "Health surveillance expenditures"),
  "surveillance_yaxis" = list("pt" = "Despesas com vigilância em saúde (R$)", "en" = "Health surveillance expenditures (R$)"),
  "screening_title" = list("pt" = "Screening de bolsas de sangue", "en" = "Blood donor screening"),
  "blood_bags" = list("pt" = "Bolsas de sangue", "en" = "Blood bags"),
  "screening_quantitative_yaxis" = list("pt" = "Bolsas de sangue examinadas", "en" = "Screened blood bags"),
  "screening_expenditures_yaxis" = list("pt" = "Despesas com screening de bolsas de sangue (R$)", "en" = "Blood bags screening test expenditures (R$)"),
  "bed_nets_card_subtitle" = list("pt" = "Despesas com mosquiteiros", "en" = "Bed nets expenditures"),
  "insecticide_box_title" = list("pt" = "Despesas com inseticida", "en" = "Insecticide expenditures"),
  "insecticide_yaxis" = list("pt" = "Despesas com inseticida (R$)", "en" = "Insecticide expenditures (R$)"),
  "human_resources_tab_title" = list("pt" = "Despesas com recursos humanos", "en" = "Human resources expenditures"),
  "numbers_incentive_card_subtitle" = list("pt" = "Municípios com incentivos federais para microscopistas", "en" = "Municipalities with federal incentives to microscopists"),
  "proportion_incentive_card_subtitle" = list("pt" = "dos municípios com incentivos federal", "en" = "of municipalities with federal incentive"),
  "human_resources_title" = list("pt" = "Recursos humanos", "en" = "Human resources"),
  "acs_number_card" = list("pt"= "Agentes Comunitários de Saúde", "en" = "Community Health Agents"),
  "microscopist_number_card" = list("pt" = "Microscopistas", "en" = "Microscopists"),
  "acs_expenditures_card" = list("pt" = "Despesas com ACS", "en" = "ACS expenditures"),
  "microscopist_expenditures_card" = list("pt" = "Despesas com microscopistas", "en" = "Microscopists expenditures"),
  "incentive_card" = list("pt" = "Incentivo federal - microscopistas", "en" = "Federal incentive - microscopists"),
  "workers" = list("pt" = "profissionais", "en" = "workers"),
  "workers_per_capita" = list("pt" = "profissionais per capita", "workers per capita"),
  "workers_per_episode" = list("pt" = "profissionais/caso", "en" = "workers/episode"),
  "ACS" = list("pt" = "ACS", "en" = "CHA"),
  "Microscopist" = list("pt" = "Microscopista", "en" = "Microscopist"),
  "quantitative_human_resources_yaxis" = list("pt" = "Profissionais de serviços de saúde", "en" = "Workers in health services"),
  "total_human_resources_names" = list("pt" = c("ACS", "Microscopista", "Incentivo"), "en" = c("CHA", "Microscopist", "Incentive")),
  "total_human_resources_yaxis" = list("pt" = "Despesas com recursos humanos (R$)", "en" = "Human resources expenditures (R$)"),
  "total_expenditures_tab_title" = list("pt" = "Despesas totais", "en" = 'Total expenditures'),
  "uf_mun" = list("pt" = "UF/Município", "en" = "State/Municipality"),
  "ipa_group" = list("pt" = "Faixa de IPA", "en" = "API group"),
  "ipa_total_comparison" = list("pt" = "Comparar com as demais faixas de IPA", "en" = "Compare with other API groups"),
  "amazonic_region" = list("pt" = "Região amazônica", "en" = "Amazonic region"),
  "group" = list("pt" = "Faixa", "en" = "Group"),
  "Zero (0)" = list("pt" = "Zero (0)", "en" = "Zero (0)"),
  "Muito baixo (<1)" = list("pt" = "Muito baixo (<1)", "en" = "Very low (<1)"),
  "Baixo (>=1 e <50)" = list("pt" = "Baixo (>=1 e <50)", "en" = "Low (>=1 and <50)"),
  "Alto (>=50)" = list("pt" = "Alto (>=50)", "en" = "High (>=50)"),
  "total_expenditures_names" = list("pt" = c("Diagnóstico e tratamento", "Vigilância e controle", "Recursos humanos"), "en" = c("Diagnosis and treatment", "Surveillance and control", "Human resources")),
  "total_expenditures_yaxis" = list("pt" = "Despesas totais com malária (R$)", "en" = "Total malaria expenditures (R$)"),
  "ipa_groups" = list("pt" = c("Zero", "Muito baixo","Baixo", "Alto"), "en" = c("Zero", "Very low", "Low","High")),
  "zero_api_subtitle_card" = list("pt" = "Despesas totais - IPA zero", "en" = "Total expenditures - zero API"),
  "very_low_api_subtitle_card" = list("pt" = "Despesas totais - IPA muito baixo", "en" = "Total expenditures - very low API"),
  "low_api_subtitle_card" = list("pt" = "Despesas totais - baixo IPA", "en" = "Total expenditures - low API"),
  "high_api_subtitle_card" = list("pt" = "Despesas totais - alto IPA", "en" = "Total expenditures - high API"),
  "epidemiological_tab_file" = list("pt" = "dados_epidemiologicos_", "en" = "epidemiological_data_"),
  "diagnostic_treatment_tab_file" = list("pt" = "dados_diagnostico_tratamento_", "en" = "diagnosis_treatment_data_"),
  "diagnostic_tab_file" = list("pt" = "dados_diagnostico_", "en" = "diagnosis_data_"),
  "treatment_tab_file" = list("pt" = "dados_tratamento_", "en" = "treatment_data_"),
  "surveillance_control_tab_file" = list("pt" = "dados_vigilancia_controle_", "en" = "surveillance_control_data_"),
  "surveillance_tab_file" = list("pt" = "dados_vigilancia_", "en" = "surveillance_data_"),
  "control_tab_file" = list("pt" = "dados_controle_", "en" = "control_data_"),
  "human_resources_tab_file" = list("pt" = "dados_recursos_humanos", "en" = "human_resources_data_"),
  "total_expenditures_tab_file" = list("pt" = "dados_despesas_totais_", "en" = "total_expenditures_data_"),
  "total_expenditures_IPA_group_tab_file" = list("pt" = "dados_despesas_totais_faixas_IPA_", "en" = "total_expenditures_API_groups_data_"),
  "total_expenditures_zero_IPA_tab_file"  = list("pt" = "dados_despesas_totais_IPA_zero", "en" = "total_expenditures_zero_API_data_"),
  "total_expenditures_very_low_IPA_tab_file"  = list("pt" = "dados_despesas_totais_IPA_muito_baixo", "en" = "total_expenditures_very_low_API_data_"),
  "total_expenditures_low_IPA_tab_file"  = list("pt" = "dados_despesas_totais_IPA_baixo_", "en" = "total_expenditures_low_API_data_"),
  "total_expenditures_high_IPA_tab_file"  = list("pt" = "dados_despesas_totais_IPA_alto_", "en" = "total_expenditures_high_API_data_"),
  "total_expenditures_amazonic_region" = list("pt" = "dados_despesas_totais_regiao_amazonica_", "en" = "total_expenditures_amazonic_region_data"),
  "epidemiological_col_names_uf" = list("pt" = c("Ano", "UF", "População", "Notificações", "Casos descartados", "Casos confirmados", "Casos confirmados (0-5 anos - Feminino)", "Casos confirmados (0-5 anos - Masculino)", "Casos confirmados (5-10 anos - Feminino)", "Casos confirmados (5-10 anos - Masculino)",  "Casos confirmados (10-15 anos - Feminino)", "Casos confirmados (10-15 anos - Masculino)",  "Casos confirmados (15-20 anos - Feminino)", "Casos confirmados (15-20 anos - Masculino)",  "Casos confirmados (20-25 anos - Feminino)", "Casos confirmados (20-25 anos - Masculino)",  "Casos confirmados (25-30 anos - Feminino)", "Casos confirmados (25-30 anos - Masculino)",  "Casos confirmados (30-35 anos - Feminino)", "Casos confirmados (30-35 anos - Masculino)",  "Casos confirmados (35-40 anos - Feminino)", "Casos confirmados (35-40 anos - Masculino)",  "Casos confirmados (40-45 anos - Feminino)", "Casos confirmados (40-45 anos - Masculino)",  "Casos confirmados (45-50 anos - Feminino)", "Casos confirmados (45-50 anos - Masculino)",  "Casos confirmados (50-55 anos - Feminino)", "Casos confirmados (50-55 anos - Masculino)",  "Casos confirmados (55-60 anos - Feminino)", "Casos confirmados (55-60 anos - Masculino)",  "Casos confirmados (60-65 anos - Feminino)", "Casos confirmados (60-65 anos - Masculino)",  "Casos confirmados (65-70 anos - Feminino)", "Casos confirmados (65-70 anos - Masculino)",  "Casos confirmados (70-75 anos - Feminino)", "Casos confirmados (70-75 anos - Masculino)",  "Casos confirmados (75-80 anos - Feminino)", "Casos confirmados (75-80 anos - Masculino)",  "Casos confirmados (80-85 anos - Feminino)", "Casos confirmados (80-85 anos - Masculino)",  "Casos confirmados (85-90 anos - Feminino)", "Casos confirmados (85-90 anos - Masculino)",  "Casos confirmados (90-95 anos - Feminino)", "Casos confirmados (90-95 anos - Masculino)",  "Casos confirmados (95<0 anos - Feminino)", "Casos confirmados (95< anos - Masculino)", "Casos não-complicados", "Casos graves", "Casos LVC", "Internações", "Número de casos - Vivax", "Número de casos - Falciparum", "Número de casos - Outros", "IPA da UF"), "en" = c("Year", "State", "Population", "Notifications", "Discarded cases", "Confirmed cases", "Confirmed cases (0-5 years - Female)", "Confirmed cases (0-5 years - Male)", "Confirmed cases (5-10 years - Female)", "Confirmed cases (5-10 years - Male)",  "Confirmed cases (10-15 years - Female)", "Confirmed cases (10-15 years - Male)",  "Confirmed cases (15-20 years - Female)", "Confirmed cases (15-20 years - Male)",  "Confirmed cases (20-25 years - Female)", "Confirmed cases (20-25 years - Male)",  "Confirmed cases (25-30 years - Female)", "Confirmed cases (25-30 years - Male)",  "Confirmed cases (30-35 years - Female)", "Confirmed cases (30-35 years - Male)",  "Confirmed cases (35-40 years - Female)", "Confirmed cases (35-40 years - Male)",  "Confirmed cases (40-45 years - Female)", "Confirmed cases (40-45 years - Male)",  "Confirmed cases (45-50 years - Female)", "Confirmed cases (45-50 years - Male)",  "Confirmed cases (50-55 years - Female)", "Confirmed cases (50-55 years - Male)",  "Confirmed cases (55-60 years - Female)", "Confirmed cases (55-60 years - Male)",  "Confirmed cases (60-65 years - Female)", "Confirmed cases (60-65 years - Male)",  "Confirmed cases (65-70 years - Female)", "Confirmed cases (65-70 years - Male)",  "Confirmed cases (70-75 years - Female)", "Confirmed cases (70-75 years - Male)",  "Confirmed cases (75-80 years - Female)", "Confirmed cases (75-80 years - Male)",  "Confirmed cases (80-85 years - Female)", "Confirmed cases (80-85 years - Male)",  "Confirmed cases (85-90 years - Female)", "Confirmed cases (85-90 years - Male)",  "Confirmed cases (90-95 years - Female)", "Confirmed cases (90-95 years - Male)",  "Confirmed cases (95<0 years - Female)", "Confirmed cases (95< years - Male)", "Non-complicated episodes", "Severe Cases", "CSV cases", "Hospitaliations", "Cases - Vivax", "Cases - Falciparum", "Cases - other types", "API")),
  "epidemiological_col_names_mun" = list("pt" = c("Ano", "UF", "Município", "População", "Notificações", "Casos descartados", "Casos confirmados", "Casos confirmados (0-5 anos - Feminino)", "Casos confirmados (0-5 anos - Masculino)", "Casos confirmados (5-10 anos - Feminino)", "Casos confirmados (5-10 anos - Masculino)",  "Casos confirmados (10-15 anos - Feminino)", "Casos confirmados (10-15 anos - Masculino)",  "Casos confirmados (15-20 anos - Feminino)", "Casos confirmados (15-20 anos - Masculino)",  "Casos confirmados (20-25 anos - Feminino)", "Casos confirmados (20-25 anos - Masculino)",  "Casos confirmados (25-30 anos - Feminino)", "Casos confirmados (25-30 anos - Masculino)",  "Casos confirmados (30-35 anos - Feminino)", "Casos confirmados (30-35 anos - Masculino)",  "Casos confirmados (35-40 anos - Feminino)", "Casos confirmados (35-40 anos - Masculino)",  "Casos confirmados (40-45 anos - Feminino)", "Casos confirmados (40-45 anos - Masculino)",  "Casos confirmados (45-50 anos - Feminino)", "Casos confirmados (45-50 anos - Masculino)",  "Casos confirmados (50-55 anos - Feminino)", "Casos confirmados (50-55 anos - Masculino)",  "Casos confirmados (55-60 anos - Feminino)", "Casos confirmados (55-60 anos - Masculino)",  "Casos confirmados (60-65 anos - Feminino)", "Casos confirmados (60-65 anos - Masculino)",  "Casos confirmados (65-70 anos - Feminino)", "Casos confirmados (65-70 anos - Masculino)",  "Casos confirmados (70-75 anos - Feminino)", "Casos confirmados (70-75 anos - Masculino)",  "Casos confirmados (75-80 anos - Feminino)", "Casos confirmados (75-80 anos - Masculino)",  "Casos confirmados (80-85 anos - Feminino)", "Casos confirmados (80-85 anos - Masculino)",  "Casos confirmados (85-90 anos - Feminino)", "Casos confirmados (85-90 anos - Masculino)",  "Casos confirmados (90-95 anos - Feminino)", "Casos confirmados (90-95 anos - Masculino)",  "Casos confirmados (95<0 anos - Feminino)", "Casos confirmados (95< anos - Masculino)", "Casos não-complicados", "Casos graves", "Casos LVC", "Internações", "Número de casos - Vivax", "Número de casos - Falciparum", "Número de casos - Outros", "IPA da UF", "IPA do munícipio"), "en" = c("Year", "State", "Municipality", "Population", "Notifications", "Discarded cases", "Confirmed cases", "Confirmed cases (0-5 years - Female)", "Confirmed cases (0-5 years - Male)", "Confirmed cases (5-10 years - Female)", "Confirmed cases (5-10 years - Male)",  "Confirmed cases (10-15 years - Female)", "Confirmed cases (10-15 years - Male)",  "Confirmed cases (15-20 years - Female)", "Confirmed cases (15-20 years - Male)",  "Confirmed cases (20-25 years - Female)", "Confirmed cases (20-25 years - Male)",  "Confirmed cases (25-30 years - Female)", "Confirmed cases (25-30 years - Male)",  "Confirmed cases (30-35 years - Female)", "Confirmed cases (30-35 years - Male)",  "Confirmed cases (35-40 years - Female)", "Confirmed cases (35-40 years - Male)",  "Confirmed cases (40-45 years - Female)", "Confirmed cases (40-45 years - Male)",  "Confirmed cases (45-50 years - Female)", "Confirmed cases (45-50 years - Male)",  "Confirmed cases (50-55 years - Female)", "Confirmed cases (50-55 years - Male)",  "Confirmed cases (55-60 years - Female)", "Confirmed cases (55-60 years - Male)",  "Confirmed cases (60-65 years - Female)", "Confirmed cases (60-65 years - Male)",  "Confirmed cases (65-70 years - Female)", "Confirmed cases (65-70 years - Male)",  "Confirmed cases (70-75 years - Female)", "Confirmed cases (70-75 years - Male)",  "Confirmed cases (75-80 years - Female)", "Confirmed cases (75-80 years - Male)",  "Confirmed cases (80-85 years - Female)", "Confirmed cases (80-85 years - Male)",  "Confirmed cases (85-90 years - Female)", "Confirmed cases (85-90 years - Male)",  "Confirmed cases (90-95 years - Female)", "Confirmed cases (90-95 years - Male)",  "Confirmed cases (95<0 years - Female)", "Confirmed cases (95< years - Male)", "Non-complicated episodes", "Severe Cases", "CSV cases", "Hospitaliations", "Cases - Vivax", "Cases - Falciparum", "Cases - other types", "API - State", "API - Municipality")),
  "diagnostic_treatment_col_names_uf" = list("pt" = c("Ano", "UF", "Quantidade de exames - Teste rápido", "Gasto com exames (R$)- Teste rápido", "Quantidade de exames - Gota espessa", "Gasto com exames (R$) - Gota espessa", "Gastos com medicamentos (R$)", "Gastos com hospitalizações (R$)"), "en" = c("Year", "State", "Tests performed - Rapid test", "Expenditures (R$) - Rapid test", "Tests performed - blood smear", "Expenditures (R$) - Blood smear", "Expenditures (R$) - Pharmaceuticals", "Expenditures (R$) - Hospitalization")),
  "diagnostic_treatment_col_names_mun" = list("pt" = c("Ano", "UF", "Município", "Quantidade de exames - Teste rápido", "Gasto com exames (R$)- Teste rápido", "Quantidade de exames - Gota espessa", "Gasto com exames (R$) - Gota espessa", "Gastos com medicamentos (R$)", "Gastos com hospitalizações (R$)"), "en" = c("Year", "State", "Municipality", "Tests performed - Rapid test", "Expenditures (R$) - Rapid test", "Tests performed - blood smear", "Expenditures (R$) - Blood smear", "Expenditures (R$) - Pharmaceuticals", "Expenditures (R$) - Hospitalization")),
  "diagnostic_col_names_uf" = list("pt" = c("Ano", "UF", "Quantidade de exames - Teste rápido", "Gasto com exames (R$)- Teste rápido", "Quantidade de exames - Gota espessa", "Gasto com exames (R$) - Gota espessa", "Quantidade de exames confirmados- Teste rápido", "Gasto com exames confirmados (R$)- Teste rápido", "Quantidade de exames confirmados- Gota espessa", "Gasto com exames confirmados (R$) - Gota espessa","Quantidade de exames (P. Vivax) - Teste rápido", "Gasto com exames (P. Vivax) (R$)- Teste rápido", "Quantidade de exames (P. Vivax)- Gota espessa", "Gasto com exames (P. Vivax) (R$) - Gota espessa","Quantidade de exames (P. Falciparum) - Teste rápido", "Gasto com exames (P. Falciparum) (R$)- Teste rápido", "Quantidade de exames (P. Falciparum)- Gota espessa", "Gasto com exames (P. Falciparum) (R$) - Gota espessa","Quantidade de exames (Outros parasitas) - Teste rápido", "Gasto com exames (Outros parasitas) (R$)- Teste rápido", "Quantidade de exames (Outros parasitas)- Gota espessa", "Gasto com exames (Outros parasitas) (R$) - Gota espessa"), "en" = c("Year", "State", "Tests performed - Rapid test", "Expenditures (R$) - Rapid test", "Tests performed - Blood smear", "Expenditures (R$) - Blood smear", "Positive tests - Rapid test", "Expenditures (R$) - Positive rapid tests", "Positive tests - blood smear", "Expenditures (R$) - Positive blood smear","Positive tests (P. Vivax) - Rapid test", "Expenditures (R$) - Positive rapid tests (P. Vivax)", "Positive tests (P. Vivax) - Blood smear", "Expenditures (R$) - Positive blood smear (P. Vivax)","Positive tests (P. Falciparum) - Rapid test", "Expenditures (R$) - Positive rapid tests (P. Falciparum)", "Positive tests - Blood smear (P. Falciparum)", "Expenditures (R$) - Positive blood smear (P. Falciparum)","Positive rapid tests (Other types)", "Expenditures (R$) - Positive rapid tests", "Positive tests - blood smear (Other types)", "Expenditures (R$) - Positive blood smear (Other types)")),
  "diagnostic_col_names_mun" = list("pt" = c("Ano", "UF", "Município", "Quantidade de exames - Teste rápido", "Gasto com exames (R$)- Teste rápido", "Quantidade de exames - Gota espessa", "Gasto com exames (R$) - Gota espessa", "Quantidade de exames confirmados- Teste rápido", "Gasto com exames confirmados (R$)- Teste rápido", "Quantidade de exames confirmados- Gota espessa", "Gasto com exames confirmados (R$) - Gota espessa","Quantidade de exames (P. Vivax) - Teste rápido", "Gasto com exames (P. Vivax) (R$)- Teste rápido", "Quantidade de exames (P. Vivax)- Gota espessa", "Gasto com exames (P. Vivax) (R$) - Gota espessa","Quantidade de exames (P. Falciparum) - Teste rápido", "Gasto com exames (P. Falciparum) (R$)- Teste rápido", "Quantidade de exames (P. Falciparum)- Gota espessa", "Gasto com exames (P. Falciparum) (R$) - Gota espessa","Quantidade de exames (Outros parasitas) - Teste rápido", "Gasto com exames (Outros parasitas) (R$)- Teste rápido", "Quantidade de exames (Outros parasitas)- Gota espessa", "Gasto com exames (Outros parasitas) (R$) - Gota espessa"), "en" = c("Year", "State", "Municipality", "Tests performed - Rapid test", "Expenditures (R$) - Rapid test", "Tests performed - Blood smear", "Expenditures (R$) - Blood smear", "Positive tests - Rapid test", "Expenditures (R$) - Positive rapid tests", "Positive tests - blood smear", "Expenditures (R$) - Positive blood smear","Positive tests (P. Vivax) - Rapid test", "Expenditures (R$) - Positive rapid tests (P. Vivax)", "Positive tests (P. Vivax) - Blood smear", "Expenditures (R$) - Positive blood smear (P. Vivax)","Positive tests (P. Falciparum) - Rapid test", "Expenditures (R$) - Positive rapid tests (P. Falciparum)", "Positive tests - Blood smear (P. Falciparum)", "Expenditures (R$) - Positive blood smear (P. Falciparum)","Positive rapid tests (Other types)", "Expenditures (R$) - Positive rapid tests", "Positive tests - blood smear (Other types)", "Expenditures (R$) - Positive blood smear (Other types)")),
  "treatment_col_names_uf" = list("pt" = c("Ano", "UF", "Gasto com medicamentos - Esquema 1 (P. Vivax) (R$)","Gasto com medicamentos - Esquema 2 (P. Falciparum) (R$)","Gasto com medicamentos - Esquemas 3 e 4 (Outros parasitas) (R$)","Gasto com medicamentos - Esquema 5 (Malária grave) (R$)", "Número de hospitalizações", "Média estadual de dias de hospitalização", "Gastos com hospitalizações (R$)"), "en" = c("Year", "State", "Pharmaceutical expenditures (R$) - Scheme 1 (P. Vivax)","Pharmaceutical expenditures (R$) - Scheme 2 (P. Falciparum)","Pharmaceutical expenditures (R$) - Schemes 3 and 4 (Other types)","Pharmaceutical expenditures (R$) - Scheme 5 (Severe disease)", "Number of hospitalizations", "Average state length of stay", "Hospitalization expenditures (R$)")),
  "treatment_col_names_mun" = list("pt" = c("Ano", "UF", "Município", "Gasto com medicamentos - Esquema 1 (P. Vivax) (R$)","Gasto com medicamentos - Esquema 2 (P. Falciparum) (R$)","Gasto com medicamentos - Esquemas 3 e 4 (Outros parasitas) (R$)","Gasto com medicamentos - Esquema 5 (Malária grave) (R$)", "Número de hospitalizações", "Dias de hospitalização", "Gastos com hospitalizações (R$)"), "en" = c("Year", "State", "Municipality","Pharmaceutical expenditures (R$) - Scheme 1 (P. Vivax)","Pharmaceutical expenditures (R$) - Scheme 2 (P. Falciparum)","Pharmaceutical expenditures (R$) - Schemes 3 and 4 (Other types)","Pharmaceutical expenditures (R$) - Scheme 5 (Severe disease)", "Number of hospitalizations", "Days of stay (hospitalizations)", "Hospitalization expenditures (R$)")),
  "surveillance_control_col_names_uf" = list("pt" = c("Ano", "UF", "Gasto com vigilância (R$)","Gasto com screening de bolsas de sangue (R$)","Gasto com mosquiteiros (R$)","Gasto com inseticida (R$)"), "en" = c("Year", "State", "Surveillance expenditures (R$)","Blood donor screening tests expenditures (R$)","Bed nets expenditures (R$)","Inseticide expenditures (R$)")),
  "surveillance_control_col_names_mun" = list("pt" = c("Ano", "UF", "Município","Gasto com vigilância (R$)","Gasto com screening de bolsas de sangue (R$)","Gasto com mosquiteiros (R$)","Gasto com inseticida (R$)"), "en" = c("Year", "State", "Municipality","Surveillance expenditures (R$)","Blood donor screening tests expenditures (R$)","Bed nets expenditures (R$)","Inseticide expenditures (R$)")),
  "surveillance_col_names_uf" = list("pt" = c("Ano", "UF", "Gasto com vigilância (R$)","Número de bolsas de sangue examinadas","Gasto com screening de bolsas de sangue (R$)"), "en" = c("Year", "State", "Surveillance expenditures (R$)","Blood bags tested","Blood donor screening tests expenditures (R$)")),
  "surveillance_col_names_mun" = list("pt" = c("Ano", "UF", "Município","Gasto com vigilância (R$)","Número de bolsas de sangue examinadas","Gasto com screening de bolsas de sangue (R$)"), "en" = c("Year", "State", "Municipality","Surveillance expenditures (R$)","Blood bags tested","Blood donor screening tests expenditures (R$)")),
  "control_col_names_uf" = list("pt" = c("Ano", "UF","Gasto com mosquiteiros (R$)","Gasto com inseticida (R$)"), "en" = c("Year", "State","Bed nets expenditures (R$)","Inseticide expenditures (R$)")),
  "control_col_names_mun" = list("pt" = c("Ano", "UF","Município","Gasto com mosquiteiros (R$)","Gasto com inseticida (R$)"), "en" = c("Year", "State","Municipality","Bed nets expenditures (R$)","Inseticide expenditures (R$)")),
  "human_resources_col_names_uf" = list("pt" = c("Ano", "UF","Número de Agentes Comunitários de Saúde","Total de salários dos Agentes Comunitários de Saúde (R$)","Número de Microscopistas", "Total de salários dos Microscopistas (R$)","Número de municípios recebedores de incentivo federal", "Total de incentivos federais (R$)"), "en" = c("Year", "State","Number of Community Health Agents","Total wages of Community Health Agents (R$)","Number of Microscopists", "Total wages of Microscopists (R$)","Number of municipalities receiving federal incentives", "Total federal incentives received (R$)")),
  "human_resources_col_names_mun" = list("pt" = c("Ano", "UF","Município","Número de Agentes Comunitários de Saúde","Total de salários dos Agentes Comunitários de Saúde (R$)","Número de Microscopistas", "Total de salários dos Microscopistas (R$)","Total de incentivos federais (R$)"), "en" = c("Year", "State","Municipality","Number of Community Health Agents","Total wages of Community Health Agents (R$)","Number of Microscopists", "Total wages of Microscopists (R$)","Total federal incentives received (R$)")),
  "total_expenditures_uf_mun_col_names_uf" = list("pt" = c("Ano","UF","Despesas totais com diagnóstico e tratamento (R$)","Despesas totais com vigilância e controle (R$)","Despesas totais com recursos humanos (R$)", "Despesas totais com malária (R$)"), "en" = c("Year", "State","Total diagnostic and treatment expenditures (R$)","Total surveillance and control expenditures (R$)","Total human resources expenditures (R$)", "Total malaria expenditures (R$)")),
  "total_expenditures_uf_mun_col_names_mun" = list("pt" = c("Ano","UF","Município","Despesas totais com diagnóstico e tratamento (R$)","Despesas totais com vigilância e controle (R$)","Despesas totais com recursos humanos (R$)", "Despesas totais com malária (R$)"), "en" = c("Year", "State","Municipality","Total diagnostic and treatment expenditures (R$)","Total surveillance and control expenditures (R$)","Total human resources expenditures (R$)", "Total malaria expenditures (R$)")),
  "total_expenditures_ipa_group_total_col_names" = list("pt" = c("Ano", "Despesas totais com diagnóstico e tratamento (R$)","Despesas totais com vigilância e controle (R$)","Despesas totais com recursos humanos (R$)", "Despesas totais com malária (R$)"), "en" = c("Year", "Total diagnostic and treatment expenditures (R$)","Total surveillance and control expenditures (R$)","Total human resources expenditures (R$)", "Total malaria expenditures (R$)")),
  "total_expenditures_ipa_group_total_comparison_col_names" = list("pt" = c("Ano","Despesas totais com malária - baixo IPA (R$)","Despesas totais com malária - médio IPA (R$)","Despesas totais com malária - alto IPA (R$)"), "en" = c("Year","Total malaria expenditures - low API (R$)","Total malaria expenditures - medium API (R$)","Total malaria expenditures - high API (R$)")),
  "intro_tab_title" = list("pt" = "Apresentação", "en" = "Introduction"),
  "intro_text_p1" = list("pt" = "Bem-vindo ao SIGAM-BR!", "en" = "Welcome to SIGAM-BR!"),
  "intro_text_p2" = list("pt" = "O SIGAM-BR é um Sistema de Informações de Gastos com Malaria nos estados da Região Amazônica Brasileira. Este sistema foi desenvolvido para estimar os gastos com malária financiados pelos municípios e governo Federal. O sistema permite desagregação das despesas anuais no nível municipal considerando três domínios principais:  Diagnostico e Tratamento, Recursos Humanos e Vigilância e Controle da malária. Esse painel traz indicadores de gasto total, per capita e por notificação e permite comparações regionais e anuais. Atualmente a plataforma está vigente para os anos de 2015 a 2019. 
", "en" = "SIGAM-BR is a System of Information on Malaria Expenditures in the states of the Brazilian Amazon Region. This system was developed to estimate malaria expenses funded by municipalities and the Federal government. The system allows for the disaggregation of annual expenses at the municipal level, considering three main domains: Diagnosis and Treatment, Human Resources, and Malaria Surveillance and Control. This dashboard provides indicators for total expenditure, per capita expenditure, and expenditure per notification, allowing for regional and annual comparisons. Currently, the platform is available for the years 2015 to 2019."),
  "intro_text_p3" = list("pt" = "O SIGAM-BR foi financiado através da Chamada CNPq/MS-SCTIE-Decit/ Fundação Bill & Melinda Gates Nº 23/2019 – Pesquisas (#442842/2019-8). O projeto foi liderado pelos pesquisadores do Grupo de Estudos em Economia da Saúde e Criminalidade – GEESC do CEDEPLAR/UFMG e do Departamento de Saúde Global e População da Escola de Saúde Pública T.H. Chan da Universidade de Harvard.", "en" = "SIGAM-BR was funded through the CNPq/MS-SCTIE-Decit/Bill & Melinda Gates Foundation Call No. 23/2019 - Research (#442842/2019-8). The project was led by researchers from the Group of Studies in Health Economics and Criminality (GEESC) at CEDEPLAR/UFMG and the Harvard T.H. Chan School of Public Health."),
  "intro_update" = list("pt" = "Última atualização:", "en" = "Last updated:"),
  "intro_date" = list("pt" = "31 de outubro de 2023.", "en" = "October 31, 2023.")
  
)

#Módulos------------------------------------------------------------------------
radio_buttons_input_ui <- function(id, label_input, choices_input){
  ns <- NS(id)
  
  radioButtons(
    inputId = (NS(id, "radio_buttons_input")),
    label = label_input,
    choices = choices_input
  )
}

radio_buttons_input_server <- function(id){
  moduleServer(id, function(input, output, session){
    option_selected <- reactive(input$radio_buttons_input)
    
    return(option_selected)
  }
  )
}

checkbox_comparison_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("checkbox_input"))
}

checkbox_comparison_server <- function(id, language){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    translation <- list(
      "comparison_label" = list("pt" = "Comparação com outras UFs/municípios", "en" = "Compare with other States/municipalities")
    )
    
    translate <- function(text){
      sapply(text, function(s) translation[[s]][[language()]], USE.NAMES=FALSE)
    }
    
    output$checkbox_input <- renderUI({
      checkboxInput(
        inputId = ns("comparison_input"),
        label = translate("comparison_label"),
        value = FALSE
      )
    })
    comparison_choice <- reactive(input$comparison_input)
    return(comparison_choice)
  })
}

visualization_menu_ui <- function(id){
  ns <- NS(id)
  uiOutput(ns("visualization_box"))
}

visualization_menu_server <- function(id, language, status_choice, width_value){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    translation <- list(
      "visualization" = list("pt" = "Visualização", "en" = "Visualization"),
      "Tendência" = list("pt" = "Tendência", "en" = "Trend"),
      "Ano escolhido" = list("pt" = "Ano escolhido", "en" = "Chosen year")
    )
    translate <- function(text){
      sapply(text, function(s) translation[[s]][[language()]], USE.NAMES=FALSE)
    }
    
    output$visualization_box <- renderUI({
      visualization_menu_values <- c("Tendência", "Ano escolhido")
      visualization_menu_choices <- structure(visualization_menu_values, .Names = translate(visualization_menu_values))
      
      box(
        title = translate("visualization"),
        solidHeader = TRUE,
        status = status_choice,
        radioButtons(
          inputId = ns("visualization_choice"),
          label = NULL,
          choices = translate(visualization_menu_choices),
        ),
        width = width_value
      )

    })
    
    visualization <- reactive(input$visualization_choice)
    return(visualization)
  })
  
  
}

uf_comparison_menu_ui <- function(id){
  ns <- NS(id)
  
  uiOutput(ns("uf_comparison_box"))
}

uf_comparison_menu_server <- function(id, uf, language, status_choice, width_choice){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    choice_vector <- sort(toupper(unique(base_dados$estado)),decreasing = FALSE)

    translation <- list(
      "comparison_label" = list("pt" = "Comparação", "en" = "Comparing to"),
      "menu_label" = list("pt" = "UFs adicionais (máximo de 8)", "en" = "Additional States (maximum of 8)")      
    )
    
    translate <- function(text){
      sapply(text, function(s) translation[[s]][[language()]], USE.NAMES=FALSE)
    }
    
    output$uf_comparison_box <- renderUI({
      box(
        title = translate("comparison_label"),
        solidHeader = TRUE,
        status = status_choice,
        selectizeInput(
          inputId = ns("uf_comparison_menu"),
          label = translate("menu_label"),
          choices = choice_vector[!choice_vector %in% uf()],
          options = list(maxItems = 8),
          multiple = TRUE
        ),
        width = width_choice
      )
    })
    
    ufs_selected <- reactive(input$uf_comparison_menu)
    
    return(ufs_selected)
  
  })
}

city_menu_ui <- function(id, status_choice, width_choice){
  ns <- NS(id)
  tagList(
    box(
      title = uiOutput(ns("title_box")),
      solidHeader = TRUE,
      status = status_choice,
      radioButtons(
        inputId = ns("city_choice"),
        label = NULL,
        choices = c("Municípios da mesma UF" = 1, "Municípios da mesma faixa de IPA" = 2),
      ),
      selectizeInput(
        inputId = ns("city_selection"),
        label =  uiOutput(ns("choice_title")),
        choices = NULL,
        options = list(maxItems = 8)
      ),
      width = width_choice
    )    
  )
}

city_menu_server <- function(id, year, uf, city, language){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$title_box <- renderUI({
      if(language() == "pt"){
        title_box <- "Comparação"
      } else{
        title_box <- "Comparing to"
      }
      
      title_box
    })
    
    output$choice_title <- renderUI({
      if(language() == "pt"){
        choice_title <- "Municípios adicionais (máximo de 8)"
      } else{
        choice_title <- "Additional municipalities (maximum of 8)"
      }
    })
    
    observeEvent(language(),
                 {
                  if(language() == "pt"){
                    updateRadioButtons(
                      inputId = "city_choice",
                      choices = c("Municípios da mesma UF" = 1, "Municípios da mesma faixa de IPA" = 2)
                    )
                  } else{
                    
                    updateRadioButtons(
                      inputId = "city_choice",
                      choices = c("Municipalities in the same State" = 1, "Municipalities in the same API group" = 2)
                    )                  }
                 }
)
    
    observeEvent({
      input$city_choice
      year()
      uf()
      city()
                  },
                 {
                   if(input$city_choice == 1){

                     choice_vector <- base_dados %>% filter(ano == year() & estado == uf()) %>% pull(nome_municipio)
                     choice_vector <- choice_vector[!choice_vector %in% city()]
                   } else{
                     IPA_comp <- base_dados %>% filter(ano == year() & estado == uf() & nome_municipio == city()) %>% pull(IPA)
                     
                     if(IPA_comp == 0){
                       mun_comp <- base_dados %>% filter(ano == year() & IPA==0) %>% select(UF, nome_municipio)
                     } else{
                       if(IPA_comp > 0 && IPA_comp <1){
                         mun_comp <- base_dados %>% filter(ano == year() & IPA >0 & IPA<1) %>% select(UF,nome_municipio)
                        } else{
                         if(IPA_comp >=1 && IPA_comp <50){
                           mun_comp <- base_dados %>% filter(ano == year() & IPA_comp >=1 & IPA<50) %>% select(UF,nome_municipio)
                         } else{
                         if(IPA_comp >= 50){
                           mun_comp <- base_dados %>% filter(ano == year() & IPA>=50) %>% select(UF,nome_municipio)
                         }                         
                       }
                     }
                     }
                     mun_comp <- mun_comp[!mun_comp$nome_municipio == city(),]
                     choice_vector <- paste(mun_comp$nome_municipio,"-",mun_comp$UF)
                   }
                   
                   updateSelectizeInput(
                     inputId = "city_selection",
                     label = NULL,
                     choices = choice_vector,
                     options = list(maxItems = 8)
                   )
                 })
    

    choice <- reactive(input$city_choice)
    comparison_vector <- reactive(input$city_selection)
    return(list(
      choice = choice,
      comparison_vector = comparison_vector
    ))
  })

}

#Criação do cabeçalho-----------------------------------------------------------

#Seleção de idiomas
language_selection <- radioButtons(
  inputId = "language_input",
  label = "",
  choiceNames = list(
    HTML("<font color = 'white'>Português</font>"),
    HTML("<font color = 'white'>English</font>")
  ),
  choiceValues = c("pt", "en"),
  selected = "pt",
  inline = TRUE
)

#Cabeçalho
header <- dashboardHeader(
  tags$li(class = "dropdown", 
          tags$style(".main-header {max-height: 60px}"),
          tags$style(".main-header .logo {height: 60px}"),
          language_selection),
  title = (tags$img("SIGAM-BR",src='logo.jpeg', height= '100%', width = '100%'))
)

#Criação do menu lateral--------------------------------------------------------

#Menu lateral
sidebar <- dashboardSidebar(
  tags$style(".left-side, .main-sidebar {padding-top: 60px}"),
  sidebarMenu(
    id = "sidebar_menu",
    menuItem(textOutput("intro_tab_title"), tabName = "intro_tab"),
    menuItem(textOutput("epidemiological_tab_title"), tabName = "epidemiological_tab"),
    menuItem(tags$div(class ="header", checked =NA, tags$p(textOutput("diagnostic_treatment_tab_title_1"), tags$br(), textOutput("diagnostic_treatment_tab_title_2"))), tabName = "diagnostic_treatment_tab", expandedName = "DIAGNOSTIC_TREATMENT",
             menuSubItem(textOutput("diagnostic_tab_title"), tabName = "diagnostic_tab"),
             menuSubItem(textOutput("treatment_tab_title"), tabName = "treatment_tab")
    ),
    menuItem(tags$div(class ="header", checked =NA, tags$p(textOutput("surveillance_control_tab_title_1"), tags$br(), textOutput("surveillance_control_tab_title_2"))), tabName = "surveillance_control_tab", expandedName = "SURVEILLANCE_CONTROL",
             menuSubItem(textOutput("surveillance_tab_title"), tabName = "surveillance_tab"),
             menuSubItem(textOutput("control_tab_title"), tabName = "control_tab")
    ),
    menuItem(textOutput("human_resources_tab_title"), tabName = "human_resources_tab"),
    menuItem(textOutput("total_expenditures_tab_title"), tabName = "total_expenditures_tab"),
  conditionalPanel(
    condition = "input.sidebar_menu != 'intro_tab'",
    uiOutput("sidebar_menu_year_input")
  ),
  conditionalPanel(
    condition = "input.sidebar_menu =='epidemiological_tab'||input.sidebar_menu =='diagnostic_treatment_tab_hidden'||input.sidebar_menu =='diagnostic_tab'||input.sidebar_menu =='treatment_tab'||input.sidebar_menu =='surveillance_control_tab_hidden'||input.sidebar_menu =='surveillance_tab'||input.sidebar_menu =='control_tab'||input.sidebar_menu =='human_resources_tab'||(input.sidebar_menu =='total_expenditures_tab' && input.total_expenditures_box == 'uf_mun_total')" ,
    uiOutput("sidebar_menu_uf_input")
  ),
  conditionalPanel(
    condition = "input.aggregation_input == 0 && (input.sidebar_menu =='epidemiological_tab'||input.sidebar_menu =='diagnostic_treatment_tab_hidden'||input.sidebar_menu =='diagnostic_tab'||input.sidebar_menu =='treatment_tab'||input.sidebar_menu =='surveillance_control_tab_hidden'||input.sidebar_menu =='surveillance_tab'||input.sidebar_menu =='control_tab'||input.sidebar_menu =='human_resources_tab'||(input.sidebar_menu =='total_expenditures_tab' && input.total_expenditures_box == 'uf_mun_total'))",
    uiOutput("sidebar_menu_city_input")    
  ),
  conditionalPanel(
    condition = "input.sidebar_menu =='epidemiological_tab'||input.sidebar_menu =='diagnostic_treatment_tab_hidden'||input.sidebar_menu =='diagnostic_tab'||input.sidebar_menu =='treatment_tab'||input.sidebar_menu =='surveillance_control_tab_hidden'||input.sidebar_menu =='surveillance_tab'||input.sidebar_menu =='control_tab'||input.sidebar_menu =='human_resources_tab'||(input.sidebar_menu =='total_expenditures_tab' && input.total_expenditures_box == 'uf_mun_total')" ,
    uiOutput("sidebar_aggregation_input")
  ),
  conditionalPanel(
    condition = "input.sidebar_menu != 'intro_tab' && input.sidebar_menu != 'epidemiological_tab' && input.sidebar_menu != 'treatment_tab'",
    uiOutput("indicators_menu")
  ),
  conditionalPanel(
    condition = "input.sidebar_menu != 'intro_tab'",
    uiOutput("download_button")
  ),
  hidden(menuItem("diagnostic_treatment_tab_hidden", tabName = "diagnostic_treatment_tab_hidden")),
  hidden(menuItem("surveillance_control_tab_hidden", tabName = "surveillance_control_tab_hidden")),
  uiOutput("style_tag")
  )
)

#Criação do corpo---------------------------------------------------------------

#Aba - "Apresentação"
intro_tab <- tabItem(
  tabName = "intro_tab",
  uiOutput("intro_text")
)

#Aba 'Informações epidemiológicas'
epidemiological_tab <- tabItem(
  tabName = "epidemiological_tab",
  useShinyjs(),
  fluidRow(
    valueBoxOutput("population_card", width = 6),
    valueBoxOutput("notifications_card", width = 6)
  ),
  fluidRow(
   uiOutput("notifications_box"),
   uiOutput("nature_box")
  ),
  fluidRow(
    uiOutput("episode_distribution_box")
  ),
  fluidRow(
    valueBoxOutput("lvc_card", width = 6),
    valueBoxOutput("hospitalization_card", width = 6)
  ),
  fluidRow(
    uiOutput("parasite_box"),
    visualization_menu_ui("parasite_visualization")
  ),
  fluidRow(
    uiOutput("ipa_box"),
    conditionalPanel(
      condition = "input['ipa_comparison-comparison_input'] == 0",
      valueBoxOutput("ipa_card")     
    ),
    conditionalPanel(
      condition = "input['ipa_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
      uf_comparison_menu_ui("ipa_uf_comparison")
    ),
    conditionalPanel(
      condition = "input['ipa_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
      city_menu_ui("ipa_selection", "danger", 4)
    )
  ),
  fluidRow(
    uiOutput("map_box")
  )
)

#Aba "Despesas com diagnóstico e tratamento"
diagnostic_treatment_tab <- tabItem(
  tabName = "diagnostic_treatment_tab_hidden",
  useShinyjs(),
  fluidRow(
    valueBoxOutput("tests_card"),
    valueBoxOutput("medicines_card"),
    valueBoxOutput("hospitalization_costs_card")
  ),
  fluidRow(
    uiOutput("total_diagnostic_treatment_box"),
    column(
      visualization_menu_ui("total_diagnostic_treatment_visualization"),
      conditionalPanel(
        condition = "input['total_diagnostic_treatment_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("total_diagnostic_treatment_uf_comparison")
      ),
      conditionalPanel(
        condition = "input['total_diagnostic_treatment_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("total_diagnostic_treatment_selection", "success", 12)
      ),
      width = 4
    )
  )
)

#Aba "Despesas com diagnóstico"
diagnostic_tab <- tabItem(
  tabName = "diagnostic_tab",
  useShinyjs(),
  uiOutput("tests_box"),
  column(
    visualization_menu_ui("tests_visualization"),
    conditionalPanel(
      condition = "input['tests_expenditures-comparison_input'] > 0 && input.aggregation_input > 0",
      uf_comparison_menu_ui("tests_uf_comparison")
    ),
    conditionalPanel(
      condition = "input['tests_expenditures-comparison_input'] > 0 && input.aggregation_input == 0",
      city_menu_ui("tests_selection", "success", 12)
    ),
    uiOutput("tests_type_box"),
    conditionalPanel(
      condition = "input['test_types_input-radio_buttons_input'] == 'Positivos'",
      uiOutput("parasite_type_box")
    ),
    width = 4
  )
)

#Aba "Despesas com tratamento"
treatment_tab <- tabItem(
  tabName = "treatment_tab",
  useShinyjs(),
  fluidRow(
    uiOutput("medicines_box"),
    column(
      conditionalPanel(
        condition = "input.medicines_box == 'total_medicines'",
        visualization_menu_ui("total_medicines_visualization"),
        uiOutput("total_medicines_indicators")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'total_medicines' && input['total_medicines-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("total_medicines_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'total_medicines' && input['total_medicines-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("total_medicines_city_comparison", "success", 12)
      ),
      conditionalPanel(
        condition = "input.medicines_box != 'total_medicines'",
        uiOutput("medicines_indicators")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'vivax_medicines' && input['vivax_medicines-comparison_input'] > 0",
        visualization_menu_ui("vivax_visualization")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'vivax_medicines' && input['vivax_medicines-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("vivax_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'vivax_medicines' && input['vivax_medicines-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("vivax_city_comparison", "success", 12)
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'falciparum_medicines' && input['falciparum_medicines-comparison_input'] > 0",
        visualization_menu_ui("falciparum_visualization")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'falciparum_medicines' && input['falciparum_medicines-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("falciparum_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'falciparum_medicines' && input['falciparum_medicines-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("falciparum_city_comparison", "success", 12)
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'others_medicines' && input['others_medicines-comparison_input'] > 0",
        visualization_menu_ui("others_visualization")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'others_medicines' && input['others_medicines-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("others_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'others_medicines' && input['others_medicines-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("others_city_comparison", "success", 12)
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'severe_medicines' && input['severe_medicines-comparison_input'] > 0",
        visualization_menu_ui("severe_visualization")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'severe_medicines' && input['severe_medicines-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("severe_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.medicines_box == 'severe_medicines' && input['severe_medicines-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("severe_city_comparison", "success", 12)
      ),
      width = 4
    )
  ),
  fluidRow(
    uiOutput("hospitalizations_box"),
    column(
      conditionalPanel(
        condition = "input.hospitalizations_box == 'quantitative_hospitalization'",
        uiOutput("quantitative_hospitalization_indicators")
      ),
      conditionalPanel(
        condition = "input.hospitalizations_box == 'length_hospitalization' && input.aggregation_input == 0",
        uiOutput("length_hospitalization_indicators")        
      ),
      conditionalPanel(
        condition = "input.hospitalizations_box == 'expenditures_hospitalization'",
        uiOutput("expenditures_hospitalization_indicators")        
      ),
      conditionalPanel(
        condition = "input.hospitalizations_box == 'expenditures_hospitalization' && input['expenditures_hospitalization-comparison_input'] > 0",
        visualization_menu_ui("expenditures_hospitalization_visualization")      
      ),
      conditionalPanel(
        condition = "input.hospitalizations_box == 'expenditures_hospitalization' && input['expenditures_hospitalization-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("hospitalization_uf_comparison")        
      ),
      conditionalPanel(
        condition = "input.hospitalizations_box == 'expenditures_hospitalization' && input['expenditures_hospitalization-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("hospitalization_city_comparison", "success", 12)        
      ),
      width = 4
    )
  )

)

#Aba "Despesas com vigilância e controle"
surveillance_control_tab <- tabItem(
  tabName = "surveillance_control_tab_hidden",
  useShinyjs(),
  fluidRow(
    valueBoxOutput("surveillance_card"),
    valueBoxOutput("insecticide_card"),
    valueBoxOutput("screening_card")
  ),
  fluidRow(
    uiOutput("total_surveillance_control_box"),
    column(
      visualization_menu_ui("total_surveillance_control_visualization"),
      conditionalPanel(
        condition = "input['total_surveillance_control_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("total_surveillance_control_uf_comparison")   
      ),
      conditionalPanel(
        condition = "input['total_surveillance_control_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("total_surveillance_control_city_comparison", "primary", 12)         
      ),
      width = 4
    )
  )
)

#Aba "Despesas com vigilância"
surveillance_tab <- tabItem(
  tabName = "surveillance_tab",
  useShinyjs(),
  fluidRow(
    uiOutput("surveillance_box"),
    column(
      conditionalPanel(
        condition = "input['surveillance_comparison-comparison_input'] > 0",
        visualization_menu_ui("surveillance_visualization")
      ),
      conditionalPanel(
        condition = "input['surveillance_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("surveillance_uf_comparison")         
      ),
      conditionalPanel(
        condition = "input['surveillance_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("surveillance_city_comparison", "primary", 12)         
      ),
      width = 4
    )
  ),
  fluidRow(
    uiOutput("screening_box"),
    column(
      conditionalPanel(
        condition = "input.screening_box == 'screening_expenditures' && input['screening_comparison-comparison_input'] > 0",
        visualization_menu_ui("screening_visualization")
      ),
      conditionalPanel(
        condition = "input.screening_box == 'screening_expenditures' && input['screening_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("screening_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.screening_box == 'screening_expenditures' && input['screening_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("screening_city_comparison", "primary", 12)
      ),
      width = 4
    )
  )
)

#Aba "Despesas com controle"
control_tab <- tabItem(
  tabName = "control_tab",
  useShinyjs(),
  conditionalPanel(
    condition = "input.year_input == 2018",
    fluidRow(
      valueBoxOutput("bed_nets_card", width = 8)
    )
  ),
  fluidRow(
    uiOutput("insecticide_box"),
    column(
      conditionalPanel(
        condition = "input['insecticide_comparison-comparison_input'] > 0",
        visualization_menu_ui("insecticide_visualization")
      ),
      conditionalPanel(
        condition = "input['insecticide_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("insecticide_uf_comparison")         
      ),
      conditionalPanel(
        condition = "input['insecticide_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("insecticide_city_comparison", "primary", 12)         
      ),
      width = 4
    )
  )
)

#Aba "Despesas com recursos humanos"
human_resources_tab <- tabItem(
  tabName = "human_resources_tab",
  useShinyjs(),
  fluidRow(
    conditionalPanel(
      condition = "input.human_resources_box == 'quantitative_human_resources'",
      valueBoxOutput("quantitative_acs_card", width = 6),
      valueBoxOutput("quantitative_microscopist_card", width = 6)
    ),
    conditionalPanel(
      condition = "input.human_resources_box == 'human_resources_expenditures'",
      valueBoxOutput("expenditures_acs_card"),
      valueBoxOutput("expenditures_microscopist_card"),
      valueBoxOutput("incentives_card")
    )
  ),
  fluidRow(
    uiOutput("human_resources_box"),
    column(
      conditionalPanel(
        condition = "input.human_resources_box == 'human_resources_expenditures'",
        visualization_menu_ui("human_resources_visualization")
      ),
      conditionalPanel(
        condition = "input.human_resources_box == 'human_resources_expenditures' && input['human_resources_comparison-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("human_resources_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.human_resources_box == 'human_resources_expenditures' && input['human_resources_comparison-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("human_resources_city_comparison", "warning", 12)
      ),
      width = 4
    ) 
  ),
  fluidRow(
    conditionalPanel(
      condition = "input.human_resources_box == 'quantitative_human_resources' && input.aggregation_input > 0 && input['indicator_input-radio_buttons_input'] == 'Valores absolutos'",
      valueBoxOutput("incentive_municipality_absolute_card", width = 6),
      valueBoxOutput("incentive_municipality_proportion_card", width = 6)
    )    
  )
)

#Aba "Despesas totais"
total_expenditures_tab <- tabItem(
  tabName = "total_expenditures_tab",
  useShinyjs(),
  conditionalPanel(
    condition = "input.total_expenditures_box == 'uf_mun_total'",
    fluidRow(
      valueBoxOutput("diagnostic_treatment_total_uf_mun"),
      valueBoxOutput("surveillance_control_total_uf_mun"),
      valueBoxOutput("human_resources_total_uf_mun")
    )
  ),
  conditionalPanel(
    condition = "input.total_expenditures_box == 'ipa_group_total' && input.ipa_total_comparison == 0",
    fluidRow(
      valueBoxOutput("diagnostic_treatment_total_ipa_group"),
      valueBoxOutput("surveillance_control_total_ipa_group"),
      valueBoxOutput("human_resources_total_ipa_group")
    )
  ),
  conditionalPanel(
    condition = "input.total_expenditures_box == 'ipa_group_total' && input.ipa_total_comparison > 0",
    fluidRow(
      valueBoxOutput("zero_api_total", width = 6),
      valueBoxOutput("very_low_api_total", width = 6)
    ),
    fluidRow(
      valueBoxOutput("low_api_total", width = 6),
      valueBoxOutput("high_api_total", width = 6)
    )
  ),
  conditionalPanel(
    condition = "input.total_expenditures_box == 'amazonic_region_total'",
    fluidRow(
      valueBoxOutput("diagnostic_treatment_total_amazonic_region"),
      valueBoxOutput("surveillance_control_amazonic_region"),
      valueBoxOutput("human_resources_total_amazonic_region")
    )
  ),
  fluidRow(
    uiOutput("total_expenditures_box"),
    column(
      conditionalPanel(
        condition = "input.total_expenditures_box == 'uf_mun_total'||input.total_expenditures_box == 'amazonic_region_total'||(input.total_expenditures_box == 'ipa_group_total' && input.ipa_total_comparison == 0)",
        visualization_menu_ui("total_expenditures_visualization")
      ),
      conditionalPanel(
        condition = "input.total_expenditures_box == 'uf_mun_total' && input['total_expenditures_uf_mun-comparison_input'] > 0 && input.aggregation_input > 0",
        uf_comparison_menu_ui("total_expenditures_uf_comparison")
      ),
      conditionalPanel(
        condition = "input.total_expenditures_box == 'uf_mun_total' && input['total_expenditures_uf_mun-comparison_input'] > 0 && input.aggregation_input == 0",
        city_menu_ui("total_expenditures_city_comparison", "danger", 12) 
      ),
      conditionalPanel(
        condition = "input.total_expenditures_box == 'ipa_group_total' && input.ipa_total_comparison == 0",
        uiOutput("ipa_group_selection_box")
      ),
      width = 4
    )
  )
)

body <- dashboardBody(
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  uiOutput('header_tag'),
  tabItems(
    intro_tab,
    epidemiological_tab,
    diagnostic_treatment_tab,
    diagnostic_tab,
    treatment_tab,
    surveillance_control_tab,
    surveillance_tab,
    control_tab,
    human_resources_tab,
    total_expenditures_tab
  )
)

#UI-----------------------------------------------------------------------------

ui <- dashboardPage(title = "SIGAM-BR",
  skin = "red",
  header,
  sidebar,
  body
)

#Servidor-----------------------------------------------------------------------
server <- function(input, output, session){
  
#Alteração dos subtítulos------------------
  output$header_tag <- renderUI({
    if(input$sidebar_menu == "epidemiological_tab"||input$sidebar_menu == "total_expenditures_tab")
      return(tags$head(tags$style(HTML('
                              /* tabBox background */                    
                              .nav-tabs-custom>.nav-tabs {
                              background-color: #d9534f;
                              }
                              
                               .nav-tabs-custom > .nav-tabs > li.header {
                               color: white;


                               }
    
                               .nav-tabs-custom>.nav-tabs>li.active{
                               border-top-color: #d9534f;
                               }
                               
                               .nav-tabs-custom>.nav-tabs>li.active:hover a, .nav-tabs-custom>.nav-tabs>li.active>a{
                               border-color: #d9534f;
                               }
                                                       
                                       
      '))))
    
    
    if(input$sidebar_menu == "diagnostic_treatment_tab"||input$sidebar_menu == "diagnostic_tab"||input$sidebar_menu == "treatment_tab")
      return(tags$head(tags$style(HTML('
                              /* tabBox background */                    
                              .nav-tabs-custom>.nav-tabs {
                              background-color: #5cb85c;
                              }
                              
                               .nav-tabs-custom > .nav-tabs > li.header {
                               color: white;


                               }
    
                               .nav-tabs-custom>.nav-tabs>li.active{
                               border-top-color: #5cb85c;
                               }
                               
                               .nav-tabs-custom>.nav-tabs>li.active:hover a, .nav-tabs-custom>.nav-tabs>li.active>a{
                               border-color: #5cb85c;
                               }
                                                       
                                       
      '))))
    
    if(input$sidebar_menu == "surveillance_control_tab"||input$sidebar_menu == "surveillance_tab"||input$sidebar_menu == "control_tab")
      return(tags$head(tags$style(HTML('
                              /* tabBox background */                    
                              .nav-tabs-custom>.nav-tabs {
                              background-color: #5bc0de;
                              }
                              
                               .nav-tabs-custom > .nav-tabs > li.header {
                               color: white;


                               }
    
                               .nav-tabs-custom>.nav-tabs>li.active{
                               border-top-color: #5bc0de;
                               }
                               
                               .nav-tabs-custom>.nav-tabs>li.active:hover a, .nav-tabs-custom>.nav-tabs>li.active>a{
                               border-color: #5bc0de;
                               }
                                                       
                                       
      '))))
    
    if(input$sidebar_menu == "human_resources_tab")
      return(tags$head(tags$style(HTML('
                              /* tabBox background */                    
                              .nav-tabs-custom>.nav-tabs {
                              background-color: #f0ad4e;
                              }
                              
                               .nav-tabs-custom > .nav-tabs > li.header {
                               color: white;


                               }
    
                               .nav-tabs-custom>.nav-tabs>li.active{
                               border-top-color: #f0ad4e;
                               }
                               
                               .nav-tabs-custom>.nav-tabs>li.active:hover a, .nav-tabs-custom>.nav-tabs>li.active>a{
                               border-color: #f0ad4e;
                               }
                                                       
                                       
      '))))
    
  })
  
#--Criação das abas escondidas-------------
  
  observeEvent(input$sidebarItemExpanded,
               {
                 if(input$sidebarItemExpanded == "DIAGNOSTIC_TREATMENT"){
                   updateTabItems(session, "sidebar_menu", selected = "diagnostic_treatment_tab_hidden")
                 }
                 
                 if(input$sidebarItemExpanded == "SURVEILLANCE_CONTROL"){
                   updateTabItems(session, "sidebar_menu", selected = "surveillance_control_tab_hidden")
                 }
               })

  
#--Variáveis de módulos--------------------
  
  parasite_choice <- visualization_menu_server("parasite_visualization", reactive(input$language_input), "danger", 4)
  ipa_comparison <- checkbox_comparison_server("ipa_comparison", reactive(input$language_input))
  ufs_ipa_comparison <- uf_comparison_menu_server("ipa_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "danger", 4)
  cities_ipa_comparison <- city_menu_server("ipa_selection", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  indicator_applied <- radio_buttons_input_server("indicator_input")
  total_diagnostic_treatment_choice <- visualization_menu_server("total_diagnostic_treatment_visualization", reactive(input$language_input), "success", 12)
  total_diagnostic_treatment_comparison <- checkbox_comparison_server("total_diagnostic_treatment_comparison", reactive(input$language_input))
  ufs_total_diagnostic_treatment_comparison <- uf_comparison_menu_server("total_diagnostic_treatment_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12)
  cities_total_diagnostic_treatment_comparison <- city_menu_server("total_diagnostic_treatment_selection", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  tests_choice <- visualization_menu_server("tests_visualization", reactive(input$language_input), "success", 12)
  test_type_chosen <- radio_buttons_input_server("test_types_input")
  parasite_type_chosen <- radio_buttons_input_server("test_parasite_types_input")
  tests_comparison <- checkbox_comparison_server("tests_expenditures", reactive(input$language_input))
  ufs_tests_comparison <- uf_comparison_menu_server("tests_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12)
  cities_tests_comparison <- city_menu_server("tests_selection", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  total_medicines_comparison <- checkbox_comparison_server("total_medicines", reactive(input$language_input))
  vivax_medicines_comparison <- checkbox_comparison_server("vivax_medicines", reactive(input$language_input))
  falciparum_medicines_comparison <- checkbox_comparison_server("falciparum_medicines", reactive(input$language_input))
  others_medicines_comparison <- checkbox_comparison_server("others_medicines", reactive(input$language_input))
  severe_medicines_comparison <- checkbox_comparison_server("severe_medicines", reactive(input$language_input))
  total_medicines_choice <- visualization_menu_server("total_medicines_visualization", reactive(input$language_input), "success", 12)
  ufs_total_medicine_comparison <- uf_comparison_menu_server("total_medicines_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12 )
  cities_total_medicine_selection <- city_menu_server("total_medicines_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  total_medicines_indicator_applied <- radio_buttons_input_server("total_medicines_indicators_input")
  medicines_indicator_applied <- radio_buttons_input_server("medicines_indicators_input")
  vivax_choice <- visualization_menu_server("vivax_visualization", reactive(input$language_input), "success", 12)
  falciparum_choice <- visualization_menu_server("falciparum_visualization", reactive(input$language_input), "success", 12)
  others_choice <- visualization_menu_server("others_visualization", reactive(input$language_input), "success", 12)
  severe_choice <- visualization_menu_server("severe_visualization", reactive(input$language_input), "success", 12)
  ufs_vivax_comparison <- uf_comparison_menu_server("vivax_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12 )
  ufs_falciparum_comparison <- uf_comparison_menu_server("falciparum_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12 )
  ufs_others_comparison <- uf_comparison_menu_server("others_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12 )
  ufs_severe_comparison <- uf_comparison_menu_server("severe_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12 )
  cities_vivax_selection <- city_menu_server("vivax_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  cities_falciparum_selection <- city_menu_server("falciparum_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  cities_others_selection <- city_menu_server("others_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  cities_severe_selection <- city_menu_server("severe_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  expenditures_hospitalization_comparison <- checkbox_comparison_server("expenditures_hospitalization", reactive(input$language_input))
  expenditures_hospitalization_choice <- visualization_menu_server("expenditures_hospitalization_visualization", reactive(input$language_input), "success", 12)
  quantitative_hospitalization_indicators_applied <- radio_buttons_input_server("quantitative_hospitalization_indicators_input")
  length_hospitalization_indicators_applied <- radio_buttons_input_server("length_hospitalization_indicators_input")
  expenditures_hospitalization_indicators_applied <- radio_buttons_input_server("expenditures_hospitalization_indicators_input")
  ufs_hospitalization_comparison <- uf_comparison_menu_server("hospitalization_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "success", 12)
  cities_hospitalization_selection <- city_menu_server("hospitalization_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  total_surveillance_control_comparison <- checkbox_comparison_server("total_surveillance_control_comparison", reactive(input$language_input))
  total_surveillance_control_choice <- visualization_menu_server("total_surveillance_control_visualization", reactive(input$language_input), "primary", 12)
  ufs_total_surveillance_control_comparison <- uf_comparison_menu_server("total_surveillance_control_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "primary", 12)
  cities_total_surveillance_control_selection <- city_menu_server("total_surveillance_control_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  surveillance_comparison <- checkbox_comparison_server("surveillance_comparison", reactive(input$language_input))
  surveillance_choice <- visualization_menu_server("surveillance_visualization", reactive(input$language_input), "primary", 12)
  ufs_surveillance_comparison <- uf_comparison_menu_server("surveillance_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "primary", 12)
  cities_surveillance_comparison <- city_menu_server("surveillance_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  screening_comparison <- checkbox_comparison_server("screening_comparison", reactive(input$language_input))
  screening_choice <- visualization_menu_server("screening_visualization", reactive(input$language_input), "primary", 12)
  ufs_screening_comparison <- uf_comparison_menu_server("screening_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "primary", 12)
  cities_screening_comparison <- city_menu_server("screening_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  insecticide_comparison <- checkbox_comparison_server("insecticide_comparison", reactive(input$language_input))
  insecticide_choice <- visualization_menu_server("insecticide_visualization", reactive(input$language_input), "primary", 12)
  ufs_insecticide_comparison <- uf_comparison_menu_server("insecticide_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "primary", 12)
  cities_insecticide_comparison <- city_menu_server("insecticide_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  human_resources_comparison <- checkbox_comparison_server("human_resources_comparison", reactive(input$language_input))
  human_resources_choice <- visualization_menu_server("human_resources_visualization", reactive(input$language_input), "warning", 12)
  ufs_human_resources_comparison <- uf_comparison_menu_server("human_resources_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "warning", 12)
  cities_human_resources_comparison <- city_menu_server("human_resources_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))
  total_expenditures_comparison <- checkbox_comparison_server("total_expenditures_uf_mun", reactive(input$language_input))
  ipa_group_total_choices <- radio_buttons_input_server("ipa_group_total_choices")
  total_expenditures_choice <- visualization_menu_server("total_expenditures_visualization", reactive(input$language_input), "danger", 12)
  ufs_total_expenditure_comparison <- uf_comparison_menu_server("total_expenditures_uf_comparison", reactive(input$uf_input), reactive(input$language_input), "danger", 12)
  cities_total_expenditures_comparison <- city_menu_server("total_expenditures_city_comparison", reactive(input$year_input),reactive(input$uf_input), reactive(input$city_input), reactive(input$language_input))

#--Funções---------------------------------

  #Tradução
  translate <- function(text){
    sapply(text, function(s) translation[[s]][[input$language_input]], USE.NAMES=FALSE)
  }
  
  #Criação de cards
  information_cards <- function(rendered_value, rendered_text, color_choice){
    valueBox(
      value = tags$p(rendered_value, style = "font-size: 80%;"),
      subtitle = rendered_text,
      color = color_choice,
    )
  }
  
  #Criação de gráficos pizza
  pie_chart <- function(data_plot, data_plot_categories, data_plot_values, text_values, colors_vector){
    plot_ly(data_plot, labels = ~data_plot_categories, values = ~data_plot_values , type = 'pie',
            textposition = "inside",
            textinfo = 'label+percent',
            insidetextfont = list(color = '#FFFFFF'),
            hoverinfo = 'text',
            text = text_values,
            marker = list(colors = colors_vector,
                          line = list(color = '#FFFFFF', width = 1))) %>%
      layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)) %>%
      toWebGL()
  }
  
  #Criação do dataframe para o mapa
  data_map_formation <- function(){
    switch(input$uf_input,
           "ACRE" = {
             if(!exists('ac_shp')){
               ac_shp <- readOGR("www", "ac", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- ac_shp
             },
           "AMAZONAS" = {
             if(!exists('am_shp')){
               am_shp <- readOGR("www", "am", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- am_shp
             },
           "AMAPÁ" = {
             if(!exists('ap_shp')){
               ap_shp <- readOGR("www", "ap", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- ap_shp
             },
           "MARANHÃO" = {
             if(!exists('ma_shp')){
               ma_shp <- readOGR("www", "ma", stringsAsFactors=FALSE, use_iconv = TRUE,encoding="UTF-8")
             }
             shp <- ma_shp
             },
           "MATO GROSSO" = {
             if(!exists('mt_shp')){
               mt_shp <- readOGR("www", "mt", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- mt_shp
             },
           "PARÁ" = {
             if(!exists('pa_shp')){
               pa_shp <- readOGR("www", "pa", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- pa_shp
             },
           "RONDÔNIA" = {
             if(!exists('ro_shp')){
               ro_shp <- readOGR("www", "ro", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- ro_shp
             },
           "RORAIMA" = {
             if(!exists('rr_shp')){
               rr_shp <- readOGR("www", "rr", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- rr_shp
             },
           "TOCANTINS" = {
             if(!exists('to_shp')){
               to_shp <- readOGR("www", "to", stringsAsFactors=FALSE, use_iconv = TRUE, encoding="UTF-8")
             }
             shp <- to_shp
             }
    )
    
    ipa_mun <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% select(munic7, IPA)
    data_map <- merge(shp, ipa_mun, by.x = "CD_MUN", by.y = "munic7")
    proj4string(data_map) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
    data_map$NM_MUN <- iconv(data_map$NM_MUN, to = "UTF-8")
    data_map$IPA[is.na(data_map$IPA)] <- 0 
    
    return(data_map)
  }
  
  #Elaboração do mapa
  map_plotting <- function(data_map){
    ipa_bins = c(0, 0.001, 1, 50, 1000)
    pal <- colorBin(c("#ffffb2", "#fecc5c", "#fd8d3c", "#f03b20"), bins = ipa_bins, na.color = "#BDBDC3")
    
    state_popup <- paste0(data_map$NM_MUN, 
                          "<br><strong>",translate("IPA"),": </strong>", 
                          data_map$IPA)
    
    leaflet(data = data_map) %>%
      addProviderTiles(providers$OpenStreetMap, options = providerTileOptions(opacity = 1), group = "Open Street Map") %>%
      addPolygons(fillColor = ~pal(data_map$IPA), 
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 1, 
                  popup = state_popup) %>%
      addLegend("bottomright",
                colors = c("#ffffb2", "#fecc5c", "#fd8d3c", "#f03b20"),
                labels = c("Zero (0)", translate("label_map_very_low"), translate("label_map_low"), translate("label_map_high")),
                title = translate("IPA"),
                opacity = 1)
  }
  
  #Criação de gráficos de linha
  line_graph <- function(data_plot, name_vector, x_title, y_title, hover_pre, hover_digit, hover_post){
    p <- plot_ly()
    
    if(ncol(data_plot) == 2){
      colnames(data_plot) <- c("ano", "y")
      
      p <- add_trace(p, x = data_plot$ano, y = data_plot$y, type = 'scatter', mode = 'lines+markers', name = name_vector, hovertemplate = paste(hover_pre, format(round(as.numeric(data_plot$y),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), line = list(color = color_vector[1]), marker = list(color = color_vector[1]))

    } else{
      for(i in 2:ncol(data_plot)){
        dataframe_temp <- data_plot[,c(1,i)]
        colnames(dataframe_temp) <- c("ano", "y")
        
        p <- add_trace(p, x = dataframe_temp$ano, y = dataframe_temp$y, type = 'scatter', mode = 'lines+markers', name = name_vector[i-1], hovertemplate = paste(hover_pre, format(round(as.numeric(dataframe_temp$y),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), line = list(color = color_vector[i-1]), marker = list(color = color_vector[i-1]))
      }
    }
    
    p <- p %>% layout(xaxis = list(title = x_title),
                      yaxis = list(title = y_title),
                      hovermode = "x unified") %>%
               toWebGL()
    
  }

  #Criação de gráficos de barra
  bar_graph <- function(data_plot, name_vector, x_title, y_title, hover_pre, hover_digit, hover_post){
    p <- plot_ly()
    q <- plot_ly()
    if(ncol(data_plot) == 2){
      colnames(data_plot) <- c("x", "y")
      
      p <- add_trace(p, x = data_plot$x, y = data_plot$y, type = 'bar', name = name_vector, hovertemplate = paste(hover_pre, format(round(as.numeric(data_plot$y),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = color_vector[1])) %>% layout(width = 200, autosize = TRUE,
                                                                                                                                                                                                                                                                                                                                    xaxis = list(title = x_title),
                                                                                                                                                                                                                                                                                                                                    yaxis = list(title = y_title),
                                                                                                                                                                                                                                                                                                                                    hovermode = "x unified") %>%
        toWebGL()
                                                                                                                                                                                                                                                                      
    } else{
      for(i in 2:ncol(data_plot)){
        width_value <- 100*(i+1)
        dataframe_temp <- data_plot[,c(1,i)]
        colnames(dataframe_temp) <- c("x", "y")
        
        q <- add_trace(q, x = dataframe_temp$x, y = dataframe_temp$y, type = 'bar', name = name_vector[i-1], hovertemplate = paste(hover_pre, format(round(as.numeric(dataframe_temp$y),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = color_vector[i-1]))%>% layout(width = width_value, autosize = TRUE,
                                                                                                                                                                                                                                                                                                                                                           xaxis = list(title = x_title),
                                                                                                                                                                                                                                                                                                                                                           yaxis = list(title = y_title),
                                                                                                                                                                                                                                                                                                                                                           hovermode = "x unified") %>%
          toWebGL()

      }
      
    }
  }
  
  #Cards com indicadores
  indicators_card <- function(variable, pre_text, number_digits_abs, number_digits, text, color_chosen){
    if(input$aggregation_input > 0){
      switch(indicator_applied(),
             "Valores absolutos" = {
               information <- paste(pre_text, format(round(as.numeric(sum((base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(variable)),na.rm = TRUE)),number_digits_abs), nsmall = number_digits_abs, big.mark = ".", decimal.mark = ",", preserve.width = "none"))
             },
             "Per capita" = {
               information <- paste(pre_text, format(round(as.numeric(sum((base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(variable)),na.rm = TRUE)/sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)),number_digits), nsmall = number_digits, big.mark = ".", decimal.mark = ",", preserve.width = "none"), "per capita")
             },
             "Por notificação" = {
               information <- paste(pre_text, format(round(as.numeric(sum((base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(variable)),na.rm = TRUE)/sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)),number_digits), nsmall = number_digits, big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("episode_card_graph"))
             }
      )
    } else{
      switch(indicator_applied(),
             "Valores absolutos" = {
               information <- paste(pre_text, format(round(as.numeric((base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable))),number_digits_abs), nsmall = number_digits_abs, big.mark = ".", decimal.mark = ",", preserve.width = "none"))
             },
             "Per capita" = {
               information <- paste(pre_text, format(round(as.numeric((base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable))/base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)),number_digits), nsmall = number_digits, big.mark = ".", decimal.mark = ",", preserve.width = "none"), "per capita")
             },
             "Por notificação" = {
               information <- paste(pre_text, format(round(as.numeric((base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable))/base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)),number_digits), nsmall = number_digits, big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("episode_card_graph"))
             }
      )
      
    }
    information_cards(information, text, color_chosen)
  }
  
  #Comparador (UF/valores absolutos/gráfico de linha)
  comparison_uf_absolute_value_line_graph <- function(variable, y_axis, hover_text, comparison_vector){
    data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
    colnames(data_plot)<- c("ano", input$uf_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
      if(length(comparison_vector) == 0){
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")
      } else{
       for(i in 1:length(comparison_vector)){
         df_temp <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
         colnames(df_temp) <- c("ano", comparison_vector[i])
         
         data_plot <- merge(data_plot, df_temp, by = "ano")
         name_vector <- colnames(data_plot)
         name_vector <- name_vector[-1]
       }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")         
      }
        }

  #Comparador (UF/média/gráfico de linha)
  comparison_uf_average_line_graph <- function(variable, variable_number, y_axis, hover_text, comparison_vector){
    data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
    data_number <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(number = sum(UQ(sym(variable_number)))) %>% arrange(ano)
    data_plot$total <- data_plot$total/data_number$number
    colnames(data_plot)<- c("ano", input$uf_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")
    } else{
      for(i in 1:length(comparison_vector)){
        df_temp <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
        number_temp <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(number = sum(UQ(sym(variable_number)))) %>% arrange(ano)
        df_temp$total <- df_temp$total/number_temp$number
        colnames(df_temp) <- c("ano", comparison_vector[i])
        
        data_plot <- merge(data_plot, df_temp, by = "ano")
        name_vector <- colnames(data_plot)
        name_vector <- name_vector[-1]
      }
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")         
    }
  }
  
  #Comparador (UF/per capita/gráfico de linha)
  comparison_uf_per_capita_line_graph <- function(variable, y_axis, hover_text, comparison_vector){
    data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
    population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
    data_plot$total <- data_plot$total/population$population
    
    colnames(data_plot)<- c("ano", input$uf_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "per capita")
    } else{
      for(i in 1:length(comparison_vector)){
        df_temp <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
        population <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
        df_temp$total <- df_temp$total/population$population
        
        colnames(df_temp) <- c("ano", comparison_vector[i])
        
        data_plot <- merge(data_plot, df_temp, by = "ano")
        name_vector <- colnames(data_plot)
        name_vector <- name_vector[-1]
      }
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "per capita")         
    }
  }

  #Comparador (UF/por caso/gráfico de linha)
  comparison_uf_per_episode_line_graph <- function(variable, y_axis, hover_text, comparison_vector){
    data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
    episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
    data_plot$total <- data_plot$total/episodes$episodes
    
    colnames(data_plot)<- c("ano", input$uf_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))
    } else{
      for(i in 1:length(comparison_vector)){
        df_temp <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
        episodes <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
        df_temp$total <- df_temp$total/episodes$episodes
        
        colnames(df_temp) <- c("ano", comparison_vector[i])
        
        data_plot <- merge(data_plot, df_temp, by = "ano")
        name_vector <- colnames(data_plot)
        name_vector <- name_vector[-1]
      }
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))         
    }
  }

  #Comparador (UF/por caso(parasita)/gráfico de linha)
  comparison_uf_per_episode_scheme_line_graph <- function(variable, scheme_chosen, y_axis, hover_text, comparison_vector){
    data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
    episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(UQ(sym(scheme_chosen)))) %>% arrange(ano)
    data_plot$total <- data_plot$total/episodes$episodes
    
    colnames(data_plot)<- c("ano", input$uf_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_scheme"))
    } else{
      for(i in 1:length(comparison_vector)){
        df_temp <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
        episodes <- base_dados %>% filter(estado == comparison_vector[i]) %>% group_by(ano) %>% summarise(episodes = sum(UQ(sym(scheme_chosen)))) %>% arrange(ano)
        df_temp$total <- df_temp$total/episodes$episodes
        
        colnames(df_temp) <- c("ano", comparison_vector[i])
        
        data_plot <- merge(data_plot, df_temp, by = "ano")
        name_vector <- colnames(data_plot)
        name_vector <- name_vector[-1]
      }
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_scheme"))         
    }
  }
  
  #Comparador (UF/valores absolutos/gráfico de barras)
  comparison_uf_absolute_value_bar_graph <- function(variable, x_axis, y_axis, hover_pre, hover_digit, hover_post, comparison_vector){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(total = sum(UQ(sym(variable))))
    data_plot <- data.frame(cbind(input$uf_input,value))
    colnames(data_plot)<- c("uf", "value")
    name_vector <- data_plot$uf
    width_value <- 200

    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      for(i in 1:length(comparison_vector)){
        value_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(total = sum(UQ(sym(variable))))
        df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
        colnames(df_temp) <- c("uf", "value")
        
        data_plot <- rbind(data_plot, df_temp)
        name_vector <- data_plot$uf
        
        ifelse(i == 1, width_value <- 400, 
               ifelse(i > 1 && i <= 3, width_value <- 500, 
                      ifelse(i > 3 && i <=5, width_value <- 600,
                             ifelse(i>5, width_value <- 700, NA))))
        
        color_applied <- color_vector[1:(i+1)]
      }
    }
    plot_ly(data_plot, x = ~uf, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }

  #Comparador (UF/média/gráfico de barras)
  comparison_uf_average_bar_graph <- function(variable, variable_number, x_axis, y_axis, hover_pre, hover_digit, hover_post, comparison_vector){
    absolute_value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(total = sum(UQ(sym(variable))))
    number <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(total = sum(UQ(sym(variable_number))))
    value <- absolute_value/number
    data_plot <- data.frame(cbind(input$uf_input,value))
    colnames(data_plot)<- c("uf", "value")
    name_vector <- data_plot$uf
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      for(i in 1:length(comparison_vector)){
        absolute_value_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(total = sum(UQ(sym(variable))))
        number_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(total = sum(UQ(sym(variable_number))))
        value_temp <- absolute_value_temp/number_temp
        df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
        colnames(df_temp) <- c("uf", "value")
        
        data_plot <- rbind(data_plot, df_temp)
        name_vector <- data_plot$uf
        
        ifelse(i == 1, width_value <- 400, 
               ifelse(i > 1 && i <= 3, width_value <- 500, 
                      ifelse(i > 3 && i <=5, width_value <- 600,
                             ifelse(i>5, width_value <- 700, NA))))
        
        color_applied <- color_vector[1:(i+1)]
      }
    }
    plot_ly(data_plot, x = ~uf, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }
  
  #Comparador (UF/per capita/gráfico de barras)
  comparison_uf_per_capita_bar_graph <- function(variable, x_axis, y_axis, hover_pre, hover_digit, comparison_vector){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(total = sum(UQ(sym(variable))))
    population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(population = sum(pop))
    data_plot <- data.frame(cbind(input$uf_input,value))
    colnames(data_plot)<- c("uf", "value")
    data_plot$value <- data_plot$value/population$population
    name_vector <- data_plot$uf
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      for(i in 1:length(comparison_vector)){
        value_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(total = sum(UQ(sym(variable))))
        population_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(population = sum(population))
        df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
        colnames(df_temp) <- c("uf", "value")
        df_temp$value <- df_temp$value/population_temp$population
        
        data_plot <- rbind(data_plot, df_temp)
        name_vector <- data_plot$uf
        
        ifelse(i == 1, width_value <- 400, 
               ifelse(i > 1 && i <= 3, width_value <- 500, 
                      ifelse(i > 3 && i <=5, width_value <- 600,
                             ifelse(i>5, width_value <- 700, NA))))
        
        color_applied <- color_vector[1:(i+1)]
      }
    }
    plot_ly(data_plot, x = ~uf, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), "per capita"), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }

  #Comparador (UF/por caso/gráfico de barras)  
  comparison_uf_per_episode_bar_graph <- function(variable, x_axis, y_axis, hover_pre, hover_digit, comparison_vector){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(total = sum(UQ(sym(variable))))
    episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(episodes = sum(notificacoes))
    data_plot <- data.frame(cbind(input$uf_input,value))
    colnames(data_plot)<- c("uf", "value")
    data_plot$value <- data_plot$value/episodes$episodes
    name_vector <- data_plot$uf
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      for(i in 1:length(comparison_vector)){
        value_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(total = sum(UQ(sym(variable))))
        episodes_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(episodes = sum(notificacoes))
        df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
        colnames(df_temp) <- c("uf", "value")
        df_temp$value <- df_temp$value/episodes_temp$episodes
        
        data_plot <- rbind(data_plot, df_temp)
        name_vector <- data_plot$uf
        
        ifelse(i == 1, width_value <- 400, 
               ifelse(i > 1 && i <= 3, width_value <- 500, 
                      ifelse(i > 3 && i <=5, width_value <- 600,
                             ifelse(i>5, width_value <- 700, NA))))
        
        color_applied <- color_vector[1:(i+1)]
      }
    }
    plot_ly(data_plot, x = ~uf, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("episode_card_graph")), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }

  #Comparador (UF/por caso(parasita)/gráfico de barras)  
  comparison_uf_per_episode_scheme_bar_graph <- function(variable, scheme_chosen, x_axis, y_axis, hover_pre, hover_digit, comparison_vector){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(total = sum(UQ(sym(variable))))
    episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(episodes = sum(UQ(sym(scheme_chosen))))
    data_plot <- data.frame(cbind(input$uf_input,value))
    colnames(data_plot)<- c("uf", "value")
    data_plot$value <- data_plot$value/episodes$episodes
    name_vector <- data_plot$uf
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      for(i in 1:length(comparison_vector)){
        value_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(total = sum(UQ(sym(variable))))
        episodes_temp <- base_dados %>% filter(ano == input$year_input & estado == comparison_vector[i]) %>% summarise(episodes = sum(UQ(sym(scheme_chosen))))
        df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
        colnames(df_temp) <- c("uf", "value")
        df_temp$value <- df_temp$value/episodes_temp$episodes
        
        data_plot <- rbind(data_plot, df_temp)
        name_vector <- data_plot$uf
        
        ifelse(i == 1, width_value <- 400, 
               ifelse(i > 1 && i <= 3, width_value <- 500, 
                      ifelse(i > 3 && i <=5, width_value <- 600,
                             ifelse(i>5, width_value <- 700, NA))))
        
        color_applied <- color_vector[1:(i+1)]
      }
    }
    plot_ly(data_plot, x = ~uf, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("episode_card_scheme")), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }
  
  #Comparador (municípios/valores absolutos/gráfico de linha)
  comparison_cities_absolute_value_line_graph <- function(variable, y_axis, hover_text, comparison_vector, comparison_type){
    data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, variable) %>% arrange(ano)
    colnames(data_plot)<- c("ano", input$city_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          df_temp <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, variable) %>% arrange(ano)
          colnames(df_temp) <- c("ano", comparison_vector[i])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")             
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          df_temp <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, variable) %>% arrange(ano)
          colnames(df_temp) <- c("ano", ini[1,1])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "")             
      }
    }
  }  
  
  #Comparador (municípios/per capita/gráfico de linha)
  comparison_cities_per_capita_line_graph <- function(variable, y_axis, hover_text, comparison_vector, comparison_type){
    data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, variable) %>% arrange(ano)
    population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
    data_plot[,2] <- data_plot[,2]/population$pop
    
    colnames(data_plot)<- c("ano", input$city_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "per capita")
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          df_temp <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, variable) %>% arrange(ano)
          population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, pop) %>% arrange(ano)
          df_temp[,2] <- df_temp[,2]/population$pop          
          
          colnames(df_temp) <- c("ano", comparison_vector[i])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "per capita")             
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          df_temp <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, variable) %>% arrange(ano)
          population <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, pop) %>% arrange(ano)
          df_temp[,2] <- df_temp[,2]/population$pop         
          
          colnames(df_temp) <- c("ano", ini[1,1])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, "per capita")             
      }
    }
  }  

  #Comparador (municípios/por caso/gráfico de linha)
  comparison_cities_per_episode_line_graph <- function(variable, y_axis, hover_text, comparison_vector, comparison_type){
    data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, variable) %>% arrange(ano)
    episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
    data_plot[,2] <- data_plot[,2]/episodes$notificacoes
    
    colnames(data_plot)<- c("ano", input$city_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          df_temp <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, variable) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, notificacoes) %>% arrange(ano)
          df_temp[,2] <- df_temp[,2]/episodes$notificacoes          
          
          colnames(df_temp) <- c("ano", comparison_vector[i])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))             
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          df_temp <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, variable) %>% arrange(ano)
          episodes <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, notificacoes) %>% arrange(ano)
          df_temp[,2] <- df_temp[,2]/episodes$notificacoes         
          
          colnames(df_temp) <- c("ano", ini[1,1])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))             
      }
    }
  }  

  #Comparador (municípios/por caso(parasita)/gráfico de linha)
  comparison_cities_per_episode_scheme_line_graph <- function(variable, scheme_chosen, y_axis, hover_text, comparison_vector, comparison_type){
    data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, variable) %>% arrange(ano)
    episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(scheme_chosen))) %>% arrange(ano)
    data_plot[,2] <- data_plot[,2]/episodes[,2]
    
    colnames(data_plot)<- c("ano", input$city_input)
    name_vector <- colnames(data_plot)
    name_vector <- name_vector[-1]
    
    if(length(comparison_vector) == 0){
      line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_scheme"))
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          df_temp <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, variable) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% select(ano, UQ(sym(scheme_chosen))) %>% arrange(ano)
          df_temp[,2] <- df_temp[,2]/episodes[,2]          
          
          colnames(df_temp) <- c("ano", comparison_vector[i])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))             
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          df_temp <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, variable) %>% arrange(ano)
          episodes <- base_dados %>% filter(UF == ini[1,2] & nome_municipio == ini[1,1]) %>% select(ano, UQ(sym(scheme_chosen))) %>% arrange(ano)
          df_temp[,2] <- df_temp[,2]/episodes[,2]         
          
          colnames(df_temp) <- c("ano", ini[1,1])
          data_plot <- merge(data_plot, df_temp, by = "ano")
          name_vector <- colnames(data_plot)
          name_vector <- name_vector[-1]
        }
        line_graph(data_plot, name_vector, translate("ano"), y_axis, hover_text, 2, translate("episode_card_graph"))             
      }
    }
  } 
  
  #Comparador (municípios/valores absolutos/gráfico de barras)
  comparison_cities_absolute_value_bar_graph <- function(variable, x_axis, y_axis, hover_pre, hover_digit, hover_post, comparison_vector, comparison_type){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable)
    data_plot <- data.frame(cbind(input$city_input,value))
    colnames(data_plot)<- c("city", "value")
    name_vector <- data_plot$city
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          value_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(variable)
          df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
          colnames(df_temp) <- c("city", "value")
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          value_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(variable)
          df_temp <- data.frame(cbind(ini[1,1], value_temp))
          colnames(df_temp) <- c("city", "value")
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      }
      

    }
    plot_ly(data_plot, x = ~city, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }

  #Comparador (municípios/per capita/gráfico de barras)
  comparison_cities_per_capita_bar_graph <- function(variable, x_axis, y_axis, hover_pre, hover_digit, comparison_vector, comparison_type){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable)
    population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
    data_plot <- data.frame(cbind(input$city_input,value))
    colnames(data_plot)<- c("city", "value")
    data_plot$value <- as.numeric(data_plot$value)/population
    name_vector <- data_plot$city
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          value_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(variable)
          population_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(pop)
          df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
          colnames(df_temp) <- c("city", "value")
          df_temp$value <- as.numeric(df_temp$value)/population_temp
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          value_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(variable)
          population_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(pop)
          df_temp <- data.frame(cbind(ini[1,1], value_temp))
          colnames(df_temp) <- c("city", "value")
          df_temp$value <- as.numeric(df_temp$value)/population_temp
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      }
      
      
    }
    plot_ly(data_plot, x = ~city, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), "per capita"), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }  
  
  #Comparador (municípios/por caso/gráfico de barras)
  comparison_cities_per_episode_bar_graph <- function(variable, x_axis, y_axis, hover_pre, hover_digit, comparison_vector, comparison_type){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable)
    episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
    data_plot <- data.frame(cbind(input$city_input,value))
    colnames(data_plot)<- c("city", "value")
    data_plot$value <- as.numeric(data_plot$value)/episodes
    name_vector <- data_plot$city
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          value_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(variable)
          episodes_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(notificacoes)
          df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
          colnames(df_temp) <- c("city", "value")
          df_temp$value <- as.numeric(df_temp$value)/episodes_temp
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          value_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(variable)
          episodes_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(notificacoes)
          df_temp <- data.frame(cbind(ini[1,1], value_temp))
          colnames(df_temp) <- c("city", "value")
          df_temp$value <- as.numeric(df_temp$value)/episodes_temp
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      }
      
      
    }
    plot_ly(data_plot, x = ~city, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("episode_card_graph")), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }  

  #Comparador (municípios/por caso(parasita)/gráfico de barras)
  comparison_cities_per_episode_scheme_bar_graph <- function(variable, scheme_chosen, x_axis, y_axis, hover_pre, hover_digit, comparison_vector, comparison_type){
    value <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(variable)
    episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(UQ(sym(scheme_chosen)))
    data_plot <- data.frame(cbind(input$city_input,value))
    colnames(data_plot)<- c("city", "value")
    data_plot$value <- as.numeric(data_plot$value)/episodes
    name_vector <- data_plot$city
    width_value <- 200
    
    if(length(comparison_vector) == 0){
      data_plot
      color_applied <- color_vector[1]
    } else{
      if(comparison_type == 1){
        for(i in 1:length(comparison_vector)){
          value_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(variable)
          episodes_temp <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == comparison_vector[i]) %>% pull(UQ(sym(scheme_chosen)))
          df_temp <- data.frame(cbind(comparison_vector[i], value_temp))
          colnames(df_temp) <- c("city", "value")
          df_temp$value <- as.numeric(df_temp$value)/episodes_temp
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      } else{
        for(i in 1:length(comparison_vector)){
          ini <- str_split_fixed(comparison_vector[i]," - ",2)
          
          value_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(variable)
          episodes_temp <- base_dados %>% filter(ano == input$year_input & UF == ini[1,2] & nome_municipio == ini[1,1]) %>% pull(UQ(sym(scheme_chosen)))
          df_temp <- data.frame(cbind(ini[1,1], value_temp))
          colnames(df_temp) <- c("city", "value")
          df_temp$value <- as.numeric(df_temp$value)/episodes_temp
          
          data_plot <- rbind(data_plot, df_temp)
          name_vector <- data_plot$city
          
          ifelse(i == 1, width_value <- 400, 
                 ifelse(i > 1 && i <= 3, width_value <- 500, 
                        ifelse(i > 3 && i <=5, width_value <- 600,
                               ifelse(i>5, width_value <- 700, NA))))
          
          color_applied <- color_vector[1:(i+1)]
        }
      }
      
      
    }
    plot_ly(data_plot, x = ~city, y = ~as.numeric(value), name = name_vector, type = "bar", hovertemplate = ~paste(hover_pre, format(round(as.numeric(value),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("episode_card_scheme")), marker = list(color = color_applied)) %>%
      layout(width = width_value, autosize = T, 
             xaxis = list(title = x_axis),
             yaxis = list(title = y_axis),
             hovermode = "x unified") %>%
      toWebGL()
  }  
    
  #Comparação (todas as possibilidades)  
  comparison_function <- function(visualization_choice, variable, x_axis_uf, x_axis_city, y_axis, hover_pre, hover_digits, hover_post, uf_comparison_vector, city_comparison_vector, city_comparison_choice, indicator_choice){
    if(visualization_choice == "Tendência"||visualization_choice == "Trend"){
      if(input$aggregation_input > 0){
        switch(indicator_choice,
               "Valores absolutos" = {
                 comparison_uf_absolute_value_line_graph(variable, y_axis, hover_pre, uf_comparison_vector)          
               },
               "Per capita" = {
                 comparison_uf_per_capita_line_graph(variable, y_axis, hover_pre, uf_comparison_vector)          
               },
               "Por notificação" = {
                 comparison_uf_per_episode_line_graph(variable, y_axis, hover_pre, uf_comparison_vector)          
               }
        )
      } else{
        switch(indicator_choice,
               "Valores absolutos" = {
                 comparison_cities_absolute_value_line_graph(variable, y_axis, hover_pre, city_comparison_vector, city_comparison_choice)                   
               },
               "Per capita" = {
                 comparison_cities_per_capita_line_graph(variable, y_axis, hover_pre, city_comparison_vector, city_comparison_choice)                   
               },
               "Por notificação" = {
                 comparison_cities_per_episode_line_graph(variable, y_axis, hover_pre, city_comparison_vector, city_comparison_choice)                   
               }
               
        )      
      }
    } else{
      if(input$aggregation_input > 0){
        switch(indicator_choice,
               "Valores absolutos" = {
                 comparison_uf_absolute_value_bar_graph(variable, x_axis_uf, y_axis, hover_pre, hover_digits, hover_post, uf_comparison_vector)          
               },
               "Per capita" = {
                 comparison_uf_per_capita_bar_graph(variable, x_axis_uf, y_axis, hover_pre, hover_digits, uf_comparison_vector)          
               },
               "Por notificação" = {
                 comparison_uf_per_episode_bar_graph(variable, x_axis_uf, y_axis, hover_pre, hover_digits, uf_comparison_vector)          
               }
               
        )      
      } else{
        switch(indicator_choice,
               "Valores absolutos" = {
                 comparison_cities_absolute_value_bar_graph(variable, x_axis_city, y_axis, hover_pre, hover_digits, hover_post, city_comparison_vector, city_comparison_choice)
               },
               "Per capita" = {
                 comparison_cities_per_capita_bar_graph(variable, x_axis_city, y_axis, hover_pre, hover_digits, city_comparison_vector, city_comparison_choice)
               },
               "Por notificação" = {
                 comparison_cities_per_episode_bar_graph(variable, x_axis_city, y_axis, hover_pre, hover_digits, city_comparison_vector, city_comparison_choice)
               }
               
        )      
      }    
    }
  }
  
  #Comparação (médias)
  average_comparison_function <- function(visualization_choice, variable_uf, variable_number, variable_city, x_axis_uf, x_axis_city,y_axis, hover_pre, uf_comparison_vector, city_comparison_vector, city_comparison_type){
    if(visualization_choice == "Tendência"||visualization_choice == "Trend"){
      if(input$aggregation_input > 0){
        comparison_uf_average_line_graph(variable_uf, variable_number, y_axis, hover_pre, uf_comparison_vector)
      } else{
        comparison_cities_absolute_value_line_graph(variable_city, y_axis, hover_pre, city_comparison_vector, city_comparison_type)
      }
    } else{
      if(input$aggregation_input > 0){
        comparison_uf_average_bar_graph(variable_uf, variable_number, x_axis_uf, y_axis, hover_pre, 2, "", uf_comparison_vector)
      } else{
        comparison_cities_absolute_value_bar_graph(variable_city, x_axis_city, y_axis, hover_pre, 2, "", city_comparison_vector, city_comparison_type)
      }    
    }
  }  
  
  #Gráficos de barras empilhadas
  stacked_bar_graph <- function(data_plot, total_plot, name_vector, hover_pre, hover_digit, hover_post, total_name, x_title, y_title){
    p <- plot_ly()
    
    for(i in 2:ncol(data_plot)){
      dataframe_temp <- data_plot[,c(1,i)]
      colnames(dataframe_temp) <- c("ano", "y")
      
      p <- add_trace(p, x = dataframe_temp$ano, y = dataframe_temp$y, type = 'bar', name = name_vector[i-1], hovertemplate = paste(hover_pre, format(round(as.numeric(dataframe_temp$y),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = color_vector[i-1]))
    }
    
    colnames(total_plot) <- c("ano", "total")
    p <- add_trace(p, x = total_plot$ano, y = total_plot$total, type = "scatter", mode = "lines+markers", name = total_name, hovertemplate = paste(hover_pre, format(round(as.numeric(total_plot$total),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), line = list(color = 'rgb(214, 39, 40)'), marker = list(color = 'rgb(214, 39, 40)'))
    
    p <- p %>% layout(xaxis = list(title = x_title),
                      yaxis = list(title = y_title), 
                      barmode = "stack",
                      hovermode = "x unified") %>%
      toWebGL()
  }

  #Indicadores no gráfico de barras empilhadas
  stacked_bar_indicators <- function(data_plot, total_plot, population, episodes, name_vector, pre_text, digits, hover_text, total_name, x_axis, y_axis, indicator_choice){
    switch(indicator_choice,
           "Valores absolutos" = {
             post_text <- ""
           },
           
           "Per capita" = {
             for(i in 2:ncol(data_plot)){
               data_plot[,i] <- data_plot[,i]/population[,2]
             }
             total_plot[,2]<-total_plot[,2]/population[,2]
             
             post_text <- "per capita"
           },
           
           "Por notificação" = {
             for(i in 2:ncol(data_plot)){
               data_plot[,i] <- data_plot[,i]/episodes[,2]
             }
             total_plot[,2]<-total_plot[,2]/episodes[,2]
             
             post_text <- translate("episode_card_graph")         
           }
           
    )
    text <- paste(hover_text, post_text)
    
    stacked_bar_graph(data_plot, total_plot, name_vector, pre_text, digits, text, total_name, x_axis, y_axis)
  }

  #Indicadores no gráfico de pizza
  pie_chart_indicators <- function(data_plot, population, episodes, pre_text, digits, hover_text, color_choice, indicator_choice){
    switch(indicator_choice,
           "Valores absolutos" = {
             post_text <- ""
           },
           "Per capita" = {
             data_plot$values <- as.numeric(data_plot$values)/population
             
             post_text <- "per capita"
           },
           "Por notificação" = {
             data_plot$values <- as.numeric(data_plot$values)/episodes
             
             post_text <- translate("episode_card_graph")
           }
           
    )
    
    final_text <- paste(hover_text, post_text)
    
    text <- paste(pre_text, prettyNum(as.numeric(format(round(as.numeric(data_plot$values), digits), nsmall = digits)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), final_text)
    
    pie_chart(data_plot, data_plot$categories, data_plot$values, text, color_choice )
  } 

  #Gráficos de exames realizados e despesas
  tests_plot_function <- function(variable_1, variable_2, variable_3, variable_4, variable_5, variable_6, variable_7,  variable_8,  variable_9,  variable_10,  variable_11,  variable_12,  variable_13,  variable_14, names_vector, pre_text, digits, post_text, total_hover_text,  x_axis, y_axis, indicator_choice){
     if(tests_choice() == "Tendência"||tests_choice() == "Trend"){
      if(input$aggregation_input > 0){
        if(test_type_chosen() == "Exames totais"){
          data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(gota_espessa = sum(UQ(sym(variable_1))),
                                                                                                       teste_rapido = sum(UQ(sym(variable_2)))) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable_3)))) %>% arrange(ano)
          
          
        } else{
          switch(parasite_type_chosen(),
                 "Todos os tipos" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(gota_espessa = sum(UQ(sym(variable_4))),
                                                                                                                teste_rapido = sum(UQ(sym(variable_5))))
                   
                   total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable_4)) + UQ(sym(variable_5))))
                 },
                 "Vivax" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(gota_espessa = sum(UQ(sym(variable_6))),
                                                                                                                teste_rapido = sum(UQ(sym(variable_7))))
                   
                   total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable_8))))
                 },
                 "Falciparum" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(gota_espessa = sum(UQ(sym(variable_9))),
                                                                                                                teste_rapido = sum(UQ(sym(variable_10))))
                   
                   total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable_11))))                 
                 },
                 "Outros" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(gota_espessa = sum(UQ(sym(variable_12))),
                                                                                                                teste_rapido = sum(UQ(sym(variable_13))))
                   
                   total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable_14))))                  
                 }
                 
          )
        }
        
        population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
        episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
      } else{
        if(test_type_chosen() == "Exames totais"){
          data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_1)), UQ(sym(variable_2))) %>% arrange(ano)
          total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_3))) %>% arrange(ano)
        } else{
          switch(parasite_type_chosen(),
                 "Todos os tipos" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_4)), UQ(sym(variable_5))) %>% arrange(ano)
                   total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_4)), UQ(sym(variable_5))) %>% arrange(ano)
                   total_plot$total <- total_plot[,2] + total_plot[,3]
                   total_plot <- total_plot[,c(1,4)]
                 },
                 "Vivax" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_6)), UQ(sym(variable_7))) %>% arrange(ano)
                   total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_8))) %>% arrange(ano)                 
                 },
                 "Falciparum" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_9)), UQ(sym(variable_10))) %>% arrange(ano)
                   total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_11))) %>% arrange(ano)                 
                 },
                 "Outros" = {
                   data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_12)), UQ(sym(variable_13))) %>% arrange(ano)
                   total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable_14))) %>% arrange(ano)                   
                 }
                 
          )
        }
        population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
        episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
      }
      stacked_bar_indicators(data_plot, total_plot, population, episodes, names_vector, pre_text, digits, post_text, total_hover_text,  x_axis, y_axis, indicator_choice)
    } else{
      if(input$aggregation_input > 0){
        if(test_type_chosen() == "Exames totais"){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(gota_espessa = sum(UQ(sym(variable_1))),
                                                                                                              teste_rapido = sum(UQ(sym(variable_2)))))
        } else{
          switch(parasite_type_chosen(),
                 "Todos os tipos" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(gota_espessa = sum(UQ(sym(variable_4))),
                                                                                                                       teste_rapido = sum(UQ(sym(variable_5)))))                   
                 },
                 "Vivax" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(gota_espessa = sum(UQ(sym(variable_6))),
                                                                                                                       teste_rapido = sum(UQ(sym(variable_7)))))                   
                 },
                 "Falciparum" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>%  summarise(gota_espessa = sum(UQ(sym(variable_9))),
                                                                                                                        teste_rapido = sum(UQ(sym(variable_10)))))                   
                 },
                 "Outros" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(gota_espessa = sum(UQ(sym(variable_12))),
                                                                                                                       teste_rapido = sum(UQ(sym(variable_13)))))                   
                 }
                 
          )
        }
        population <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)
        episodes <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)
      } else{
        if(test_type_chosen() == "Exames totais"){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(UQ(sym(variable_1)), UQ(sym(variable_2))))         
        } else{
          switch(parasite_type_chosen(),
                 "Todos os tipos" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(UQ(sym(variable_4)), UQ(sym(variable_5))))                   
                 },
                 "Vivax" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(UQ(sym(variable_6)), UQ(sym(variable_7))))                   
                 },
                 "Falciparum" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(UQ(sym(variable_9)), UQ(sym(variable_10))))                   
                 },
                 "Outros" = {
                   values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(UQ(sym(variable_12)), UQ(sym(variable_13))))                   
                 }
                 
          )          
        }
        population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
        episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
      }
      data_plot <- data.frame(cbind(names_vector, values))
      colnames(data_plot) <- c("categories", "values")
      colors <- c('rgb(0,0,139)','rgb(102,205,0)')
      
      pie_chart_indicators(data_plot, population, episodes, pre_text, digits, post_text, colors, indicator_applied())
    }
  }      
  
  #Gráficos de despesas com esquemas de medicamentos
  medicine_scheme_plot <- function(scheme_comparison, visualization_choice, indicators_scheme, variable, scheme_cases, name_vector, y_title, uf_comparison_vector, city_comparison_vector, city_comparison_type){
     if(scheme_comparison == 0){
      if(input$aggregation_input > 0){
        data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(value = sum(UQ(sym(variable)))) %>% arrange(ano)
        switch(indicators_scheme,
               "Valores absolutos" = {
                 hover_post <- ""
               },
               "Per capita" = {
                 population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
                 data_plot$value <- data_plot$value/population$population
                 hover_post <- "per capita"
               },
               "Por notificação (todos os esquemas)" = {
                 all_episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
                 data_plot$value <- data_plot$value/all_episodes$episodes
                 hover_post <- translate("episode_card_graph")
               },
               "Por caso (esquema escolhido)" = {
                 scheme_episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(UQ(sym(scheme_cases)))) %>% arrange(ano)
                 data_plot$value <- data_plot$value/scheme_episodes$episodes
                 hover_post <- translate("episode_card_scheme")                   
               }
               
        )
      } else{
        data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable))) %>% arrange(ano)
        switch(indicators_scheme,
               "Valores absolutos" = {
                 hover_post <- ""
               },
               "Per capita" = {
                 population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
                 data_plot[,2] <- data_plot[,2]/population$pop
                 hover_post <- "per capita"
               },
               "Por notificação (todos os esquemas)" = {
                 all_episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
                 data_plot[,2] <- data_plot[,2]/all_episodes$notificacoes
                 hover_post <- translate("episode_card_graph")
               },
               "Por caso (esquema escolhido)" = {
                 scheme_episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(scheme_cases))) %>% arrange(ano)
                 data_plot[,2] <- data_plot[,2]/scheme_episodes[,2]
                 hover_post <- translate("episode_card_scheme")                   
               }
               
        )          
      }
      line_graph(data_plot, name_vector, translate("ano"), y_title, "R$", 2, hover_post)
    } else{
      if(visualization_choice == "Tendência"||visualization_choice == "Trend"){
        if(input$aggregation_input > 0){
          switch(indicators_scheme,
                 "Valores absolutos" = {
                   comparison_uf_absolute_value_line_graph(variable, y_title, "R$", uf_comparison_vector)
                 },
                 "Per capita" = {
                   comparison_uf_per_capita_line_graph(variable, y_title, "R$", uf_comparison_vector)
                 },
                 "Por notificação (todos os esquemas)" = {
                   comparison_uf_per_episode_line_graph(variable, y_title, "R$", uf_comparison_vector)
                 },
                 "Por caso (esquema escolhido)" = {
                   comparison_uf_per_episode_scheme_line_graph(variable, scheme_cases, y_title, "R$", uf_comparison_vector)
                 }
                 
          )          
        } else{
          switch(indicators_scheme,
                 "Valores absolutos" = {
                   comparison_cities_absolute_value_line_graph(variable, y_title, "R$", city_comparison_vector, city_comparison_type)
                 },
                 "Per capita" = {
                   comparison_cities_per_capita_line_graph(variable, y_title, "R$", city_comparison_vector, city_comparison_type)
                 },
                 "Por notificação (todos os esquemas)" = {
                   comparison_cities_per_episode_line_graph(variable, y_title, "R$", city_comparison_vector, city_comparison_type)
                 },
                 "Por caso (esquema escolhido)" = {
                   comparison_cities_per_episode_scheme_line_graph(variable, scheme_cases, y_title, "R$", city_comparison_vector, city_comparison_type)
                 }
                 
          )          
        }        
      } else{
        if(input$aggregation_input > 0){
          switch(indicators_scheme,
                 "Valores absolutos" = {
                   comparison_uf_absolute_value_bar_graph(variable, translate("uf"), y_title, "R$", 2, "", uf_comparison_vector)
                 },
                 "Per capita" = {
                   comparison_uf_per_capita_bar_graph(variable, translate("uf"), y_title, "R$", 2, uf_comparison_vector)
                 },
                 "Por notificação (todos os esquemas)" = {
                   comparison_uf_per_episode_bar_graph(variable, translate("uf"), y_title, "R$", 2, uf_comparison_vector)
                 },
                 "Por caso (esquema escolhido)" = {
                   comparison_uf_per_episode_scheme_bar_graph(variable, scheme_cases, translate("uf"), y_title, "R$", 2, uf_comparison_vector)
                 }
                 
          )          
        } else{
          switch(indicators_scheme,
                 "Valores absolutos" = {
                   comparison_cities_absolute_value_bar_graph(variable, translate("city"), y_title, "R$", 2, "", city_comparison_vector, city_comparison_type)
                 },
                 "Per capita" = {
                   comparison_cities_per_capita_bar_graph(variable, translate("city"), y_title, "R$", 2, city_comparison_vector, city_comparison_type)
                 },
                 "Por notificação (todos os esquemas)" = {
                   comparison_cities_per_episode_bar_graph(variable, translate("city"), y_title, "R$", 2, city_comparison_vector, city_comparison_type)
                 },
                 "Por caso (esquema escolhido)" = {
                   comparison_cities_per_episode_scheme_bar_graph(variable, scheme_cases, translate("city"), y_title, "R$", 2, city_comparison_vector, city_comparison_type)
                 }
                 
          )          
        }        
      }      
    }
  }

  #Graficos de linhas com indicadores
  line_graph_indicators <- function(indicator_chosen, variable, digits_absolute, name_vector, x_title, y_title, hover_pre){
    if(input$aggregation_input > 0){
      data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(UQ(sym(variable)))) %>% arrange(ano)
      switch(indicator_chosen,
             "Valores absolutos" = {
               hover_post <- ""
               digits <- digits_absolute
             },
             "Per capita" = {
               population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               data_plot$total <- data_plot$total/population$population
               hover_post <- "per capita"
               digits <- 2
             },
             "Por notificação" = {
               episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               data_plot$total <- data_plot$total/episodes$episodes
               hover_post <- translate("episode_card_graph")
               digits <- 2
             }
      )
    } else{
      data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, UQ(sym(variable))) %>% arrange(ano)
      switch(indicator_chosen,
             "Valores absolutos" = {
               hover_post <- ""
               digits <- digits_absolute               
             },
             "Per capita" = {
               population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
               data_plot[,2] <- data_plot[,2]/population$pop
               hover_post <- "per capita"
               digits <- 2
             },
             "Por notificação" = {
               episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
               data_plot[,2] <- data_plot[,2]/episodes$notificacoes
               hover_post <- translate("episode_card_graph")
               digits <- 2
             }
      )      
    }
    line_graph(data_plot, name_vector, x_title, y_title, hover_pre, digits, hover_post)
    
  }
  
#--UI dinâmico-----------------------------
      
  #Tradução do título das abas
  output$intro_tab_title <- renderText({
    translate("intro_tab_title")
  })
  
  output$epidemiological_tab_title <- renderText({
    translate("epidemiological_tab_title")
  })
  
  output$diagnostic_treatment_tab_title_1 <- renderText({
    translate("diagnostic_treatment_tab_title_1")
  })
  
  output$diagnostic_treatment_tab_title_2 <- renderText({
    translate("diagnostic_treatment_tab_title_2")
  })
  
  output$diagnostic_tab_title <- renderText({
    translate("diagnostic_tab_title")
  })
  
  output$treatment_tab_title <- renderText({
    translate("treatment_tab_title")
  })
  
  output$surveillance_control_tab_title_1 <- renderText({
    translate("surveillance_control_tab_title_1")
  })
  
  output$surveillance_control_tab_title_2 <- renderText({
    translate("surveillance_control_tab_title_2")
  })
  
  output$surveillance_tab_title <- renderText({
    translate("surveillance_tab_title")
  })
  
  output$control_tab_title <- renderText({
    translate("control_tab_title")
  })
  
  output$human_resources_tab_title <- renderText({
    translate("human_resources_tab_title")
  })
  
  output$total_expenditures_tab_title <- renderText({
    translate("total_expenditures_tab_title")
  })
  
  #Menu de seleção dos inputs (ano, UF, município)
  output$sidebar_menu_year_input <- renderUI({
    selectizeInput(
      inputId = "year_input",
      label = translate("Ano"),
      choices = sort(unique(base_dados$ano), decreasing = FALSE)
    )
  })
  
  output$sidebar_menu_uf_input <- renderUI({  
    selectizeInput(
      inputId = "uf_input",
      label = translate("UF"),
      choices = sort(unique(base_dados$estado), decreasing = FALSE)
    )
  })
  
  output$sidebar_menu_city_input <- renderUI({
    selectizeInput(
      inputId = "city_input",
      label = translate("Município"),
      choices = na.omit(sort(unique(base_dados$nome_municipio[base_dados$estado == input$uf_input]), decreasing = FALSE))
    )
  })

  #Seleção do nível de agregação
  output$sidebar_aggregation_input <- renderUI({
    checkboxInput(
      inputId = "aggregation_input",
      label = translate("Todos os municípios"),
      value = TRUE
    )
  })
  
  #Menu de indicadores
  output$indicators_menu <- renderUI({
    choices_values <- c("Valores absolutos", "Per capita", "Por notificação")
    choices_indicators <- structure(choices_values, .Names = translate(choices_values))
    
    radio_buttons_input_ui("indicator_input", translate("indicators_label"), choices_indicators)
  })
  
  #Texto da aba "Apresentação"
  output$intro_text <- renderUI({
    fluidRow(
      box(
        solidHeader = TRUE,
        width = 12,
        h3(translate("intro_text_p1"),style="text-align:justify; color:black;'"),
        br(),
        p(translate("intro_text_p2"),style="line-height:2; font-family: 'helvetica'; font-si18pt; text-align:justify; color:black;'"),
        br(),
        p(translate("intro_text_p3"),style="line-height:2; font-family: 'helvetica'; font-si18pt; text-align:justify; color:black;'"),
        br(),
        p(strong(translate("intro_update")),translate("intro_date"),style="line-height:2; font-family: 'helvetica'; font-si18pt; text-align:justify; color:black;'"),
        img(src = "banner.jpeg", height = '100%', width = '100%')
      ),
      conditionalPanel(
        condition = 'input.language_input == "pt"',
        div(
          style = "position:relative; left:calc(44.5%);",
          downloadButton(
            outputId = "download_note",
            label = "Nota metodológica",
            style = "color: #fff; background-color: #27ae60; border-color: #fff;"
          ) 
        )
      )
    )

  })
  
  #Download da aba "Apresentação"
  output$download_note <- downloadHandler(
    filename = function(){"nota_metodologica_sigam_br.pdf"},
    content = function(file){
      file.copy("www/nota_metododologica_sigam_br.pdf", file)

  })

  #Box de perfil das notificações
  output$notifications_box <- renderUI({
    box(
      title = translate("profile_notifications"),
      solidHeader = TRUE,
      status = "danger",
      withSpinner(plotlyOutput("notifications_plot"), type = '8'),
      width = 6
    )
  })

  #Box de gravidade dos casos
  output$nature_box <- renderUI({
    box(
      title = translate("severity_episodes"),
      solidHeader = TRUE,
      status = "danger",
      withSpinner(plotlyOutput("nature_plot"), type = '8'),
      width = 6
    )
  })
  
  #Box de distribuição dos casos
  output$episode_distribution_box <- renderUI({
    tabBox(
      id = "profile_box",
      width = 12,
      title = translate("episodes_distribution_title"),
      tabPanel(translate("age_pyramid"), id = "pyramid_profile", value = "pyramid_profile",
               withSpinner(plotlyOutput("pyramid_plot"), type = '8')),
      tabPanel(translate("gender"), id = "gender_profile", value = "gender_profile",
               withSpinner(plotlyOutput("gender_plot"), type = '8')),
      tabPanel(translate("age_group"), id = "age_profile", value = "age_profile",
               withSpinner(plotlyOutput("age_plot"), type = '8'))
    )
  })
  
  #Box do mapa
  output$map_box <- renderUI({
    box(
      title = translate("map_box"),
      solidHeader = TRUE,
      status = "danger",
      withSpinner(leafletOutput("map_plot"), type = '8'),
      width = 12
    )
  })
  
  #Box do tipo de parasita
  output$parasite_box <- renderUI({
    box(
      title = translate("parasite_type"),
      solidHeader = TRUE,
      status = "danger",
      withSpinner(plotlyOutput("parasite_plot"), type = '8'),
      width = 8
    )
  })
  
  #Box da tendência de IPA
  output$ipa_box <- renderUI({
    box(
      title = translate("ipa_title"),
      solidHeader = TRUE,
      status = "danger",
      withSpinner(plotlyOutput("ipa_plot"), type = '8'),
      checkbox_comparison_ui("ipa_comparison"),
      width = 8
    )
  })
  
  #Box do total de gastos com diagnóstico e tratamento
  output$total_diagnostic_treatment_box <- renderUI({
    box(
      title = translate("total_diagnostic_treatment_title"),
      solidHeader = TRUE,
      status = "success",
      withSpinner(plotlyOutput("total_diagnostic_treatment_plot"), type = '8'),
      checkbox_comparison_ui("total_diagnostic_treatment_comparison"),
      width = 8
    )
  })
  
  #Box dos testes
  output$tests_box <- renderUI({
    tabBox(
      id = "tests_box",
      width = 8,
      title = translate("tests_title"),
      tabPanel(translate("quantitative"), id = "quantitative_tests", value = "quantitative_tests",
               withSpinner(plotlyOutput("tests_quantitative_plot"), type = '8')),
      tabPanel(translate("expenditures"), id = "quantitative_expenditures", value = "quantitative_expenditures",
               withSpinner(plotlyOutput("tests_expenditures_plot"), type = '8'),
               checkbox_comparison_ui("tests_expenditures"))
    )
  })
  
  #Box do tipo dos testes
  output$tests_type_box <- renderUI({
    test_values <- c("Exames totais", "Positivos")
    test_types <- structure(test_values, .Names = translate(test_values))
    
    box(
      title = translate("tests_type_title"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("test_types_input", NULL, test_types),
      width = 12
    )
  })
  
  #Box da escolha do parasita (teste)
  output$parasite_type_box <- renderUI({
    parasite_tests_value <- c("Todos os tipos", "Vivax", "Falciparum", "Outros")
    parasite_tests_types <- structure(parasite_tests_value, .Names = translate(parasite_tests_value))
    
    box(
      title = translate("parasite_type"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("test_parasite_types_input", NULL, parasite_tests_types),
      width = 12
    )    
  })
  
  #Box dos medicamentos
  output$medicines_box <- renderUI({
    tabBox(
      id = "medicines_box",
      width = 8,
      title = translate("medicines_title"),
      tabPanel(translate("total_name"), id = "total_medicines", value = "total_medicines",
               withSpinner(plotlyOutput("total_medicines_plot"), type = '8'),
               checkbox_comparison_ui("total_medicines")),
      tabPanel("Vivax", id = "vivax_medicines", value = "vivax_medicines",
               withSpinner(plotlyOutput("vivax_medicines_plot"), type = '8'),
               checkbox_comparison_ui("vivax_medicines")),
      tabPanel("Falciparum", id = "falciparum_medicines", value = "falciparum_medicines",
               withSpinner(plotlyOutput("falciparum_medicines_plot"), type = '8'),
               checkbox_comparison_ui("falciparum_medicines")),
      tabPanel(translate("Outros"), id = "others_medicines", value = "others_medicines",
               withSpinner(plotlyOutput("others_medicines_plot"), type = '8'),
               checkbox_comparison_ui("others_medicines")),
      tabPanel(translate("severe"), id = "severe_medicines", value = "severe_medicines",
               withSpinner(plotlyOutput("severe_medicines_plot"), type = '8'),
               checkbox_comparison_ui("severe_medicines"))
    )    
  })

  #Box dos indicadores (despesas totais com medicamentos)
  output$total_medicines_indicators <- renderUI({
    total_medicines_values <- c("Valores absolutos", "Per capita", "Por notificação")
    total_medicines_choices <- structure(total_medicines_values, .Names = translate(total_medicines_values))
    
    box(
      title = translate("indicators"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("total_medicines_indicators_input", NULL, total_medicines_choices),
      width = 12
    )
  })
  
  #Box dos indicadores (medicamentos/por esquema)
  output$medicines_indicators <- renderUI({
    medicines_values <- c("Valores absolutos", "Per capita", "Por notificação (todos os esquemas)", "Por caso (esquema escolhido)")
    medicines_choices <- structure(medicines_values, .Names = translate(medicines_values))
    
    box(
      title = translate("indicators"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("medicines_indicators_input", NULL, medicines_choices),
      width = 12
    )
  })
  
  #Box das despesas com hospitalizações
  output$hospitalizations_box <- renderUI({
    tabBox(
      id = "hospitalizations_box",
      width = 8,
      title = translate("Hospitalizações"),
      tabPanel(translate("quantitative"), id = "quantitative_hospitalization", value = "quantitative_hospitalization",
               withSpinner(plotlyOutput("quantitative_hospitalization_plot"), type = '8')),
      tabPanel(translate("length"), id = "length_hospitalization", value = "length_hospitalization",
               withSpinner(plotlyOutput("length_hospitalization_plot"), type = '8')),
      tabPanel(translate("expenditures"), id = "expenditures_hospitalization", value = "expenditures_hospitalization",
               withSpinner(plotlyOutput("expenditures_hospitalization_plot"), type = '8'),
               checkbox_comparison_ui("expenditures_hospitalization"))      
    )
  })
  
  #Box dos indicadores (quantitativo - hospitalizações)
  output$quantitative_hospitalization_indicators <- renderUI({
    quantitative_hospitalization_values <- c("Valores absolutos", "Per capita", "Por notificação")
    quantitative_hospitalization_choices <- structure(quantitative_hospitalization_values, .Names = translate(quantitative_hospitalization_values))
    
    box(
      title = translate("indicators"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("quantitative_hospitalization_indicators_input", NULL, quantitative_hospitalization_choices),
      width = 12
    )    
  })
  
  #Box dos indicadores (duração - hospitalizações)
  output$length_hospitalization_indicators <- renderUI({
    length_hospitalization_values <- c("Valores absolutos", "Média")
    length_hospitalization_choices <- structure(length_hospitalization_values, .Names = translate(length_hospitalization_values))
    
    box(
      title = translate("indicators"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("length_hospitalization_indicators_input", NULL, length_hospitalization_choices),
      width = 12
    )     
  })

  #Box dos indicadores (despesas - hospitalizações)  
  output$expenditures_hospitalization_indicators <- renderUI({
    expenditures_hospitalization_values <- c("Valores absolutos", "Média","Per capita", "Por notificação")
    expenditures_hospitalization_choices <- structure(expenditures_hospitalization_values, .Names = translate(expenditures_hospitalization_values))
    
    box(
      title = translate("indicators"),
      solidHeader = TRUE,
      status = "success",
      radio_buttons_input_ui("expenditures_hospitalization_indicators_input", NULL, expenditures_hospitalization_choices),
      width = 12
    )     
  })
  
  #Box do total de gastos com vigilância e controle
  output$total_surveillance_control_box <- renderUI({
    box(
      title = translate("total_surveillance_control_title"),
      solidHeader = TRUE,
      status = "primary",
      withSpinner(plotlyOutput("total_surveillance_control_plot"), type = '8'),
      checkbox_comparison_ui("total_surveillance_control_comparison"),
      width = 8
    )
  })
  
  #Box das despesas com vigilància
  output$surveillance_box <- renderUI({
    box(
      title = translate("surveillance_box_title"),
      solidHeader = TRUE,
      status = "primary",
      withSpinner(plotlyOutput("surveillance_plot"), type = '8'),
      checkbox_comparison_ui("surveillance_comparison"),
      width = 8
    )
  })
  
  #Box de screening
  output$screening_box <- renderUI({
    tabBox(
      id = "screening_box",
      width = 8,
      title = translate("screening_title"),
      tabPanel(translate("quantitative"), id = "quantitative_screening", value = "quantitative_screening",
               withSpinner(plotlyOutput("screening_quantitative_plot"), type = '8')),
      tabPanel(translate("expenditures"), id = "screening_expenditures", value = "screening_expenditures",
               withSpinner(plotlyOutput("screening_expenditures_plot"), type = '8'),
               checkbox_comparison_ui("screening_comparison"))
    )
  })
  
  #Box das despesas com inseticida
  output$insecticide_box <- renderUI({
    box(
      title = translate("insecticide_box_title"),
      solidHeader = TRUE,
      status = "primary",
      withSpinner(plotlyOutput("insecticide_plot"), type = '8'),
      checkbox_comparison_ui("insecticide_comparison"),
      width = 8
    )
  })
  
  #Box de recursos humanos
  output$human_resources_box <- renderUI({
    tabBox(
      id = "human_resources_box",
      width = 8,
      title = translate("human_resources_title"),
      tabPanel(translate("quantitative"), id = "quantitative_human_resources", value = "quantitative_human_resources",
               withSpinner(plotlyOutput("human_resources_quantitative_plot"), type = '8')),
      tabPanel(translate("expenditures"), id = "human_resources_expenditures", value = "human_resources_expenditures",
               withSpinner(plotlyOutput("human_resources_expenditures_plot"), type = '8'),
               checkbox_comparison_ui("human_resources_comparison"))
    )
  })
  
  #Box de despesas totais
  output$total_expenditures_box <- renderUI({
    tabBox(
      id = "total_expenditures_box",
      width = 8,
      title = translate("total_expenditures_tab_title"),
      tabPanel(translate("uf_mun"), id = "uf_mun_total", value = "uf_mun_total",
               withSpinner(plotlyOutput("total_expenditures_uf_mun_plot"), type = '8'),
               checkbox_comparison_ui("total_expenditures_uf_mun")),
      tabPanel(translate("ipa_group"), id = "ipa_group_total", value = "ipa_group_total",
               withSpinner(plotlyOutput("total_expenditures_ipa_group_plot"), type = '8'),
               checkboxInput(
                 inputId = "ipa_total_comparison",
                 label = translate("ipa_total_comparison"),
                 value = FALSE
               )),
      tabPanel(translate("amazonic_region"), id = "amazonic_region_total", value = "amazonic_region_total",
               withSpinner(plotlyOutput("total_expenditures_amazon_region_plot"), type = '8'))
    )    
  })
  
  #Box da seleção da faixa de IPA (despesas totais)
  output$ipa_group_selection_box <- renderUI({
    ipa_group_values <- c("Zero (0)", "Muito baixo (<1)","Baixo (>=1 e <50)", "Alto (>=50)")
    ipa_group_choices <- structure(ipa_group_values, .Names = translate(ipa_group_values))
    
    box(
      title = translate("group"),
      solidHeader = TRUE,
      status = "danger",
      radio_buttons_input_ui("ipa_group_total_choices", NULL, ipa_group_choices),
      width = 12
    )
  })

#--Cards-----------------------------------
  
    
  #População
  output$population_card <- renderValueBox({
    if(input$aggregation_input > 0){
      population <- prettyNum(sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop), na.rm = TRUE), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    } else{
      population <- prettyNum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    }
    
    information_cards(population, translate("População"), "red")
  })
  
  #Notificações
  output$notifications_card <- renderValueBox({
     if(input$aggregation_input > 0){
      notifications <- prettyNum(sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes), na.rm = TRUE), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    } else{
      notifications <- prettyNum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    }
    
    information_cards(notifications, translate("Notificações"), "red")
  })
  
  #Casos LVC
  output$lvc_card <- renderValueBox({
    if(input$aggregation_input > 0){
      lvc <- prettyNum(sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(casos_lvc), na.rm = TRUE), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    } else{
      lvc <- prettyNum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_lvc), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    }
    
    information_cards(lvc, translate("LVC"), "red")
  })
  
  #Hospitalizações
  output$hospitalization_card <- renderValueBox({
    if(input$aggregation_input > 0){
      hospitalization <- prettyNum(sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(hospitalizacoes_n), na.rm = TRUE), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    } else{
      hospitalization <- prettyNum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(hospitalizacoes_n), big.mark = ".", decimal.mark = ",", preserve.width = "none")
    }
    
    information_cards(hospitalization, translate("Hospitalizações"), "red")
  })
  
  #IPA
  output$ipa_card <- renderValueBox({
    if(input$aggregation_input > 0){
      ipa <- prettyNum(as.numeric(format(round(as.numeric(base_ipa_uf %>% filter(ano == input$year_input) %>% pull(input$uf_input)), 2), nsmall = 2)), big.mark = ".", decimal.mark = ",", preserve.width = "none")
      subtitle_ipa <- paste(translate("ipa_graph"), input$uf_input, " (", input$year_input, ")")
    } else{
      ipa <- prettyNum(as.numeric(format(round(as.numeric(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(IPA)), 2), nsmall = 2)), big.mark = ".", decimal.mark = ",", preserve.width = "none")
      subtitle_ipa <- paste(translate("ipa_graph"), input$city_input, " (", input$year_input, ")")      
    }
    
    valueBox(
      value = ipa,
      subtitle = subtitle_ipa,
      color = "red"
    )
  })
  
  #Despesas com exames
  output$tests_card <- renderValueBox({
    indicators_card("gasto_exame_total", "R$", 2, 2, translate("tests_card_text"), "green")
  })
  
  #Despesas com medicamentos
  output$medicines_card <- renderValueBox({
    indicators_card("medicamento_total", "R$", 2, 2, translate("medicines_card_text"), "green")
  })
  
  #Despesas com hospitalizações
  output$hospitalization_costs_card <- renderValueBox({
    indicators_card("hospitalizacoes_gasto", "R$", 2, 2, translate("hospitalization_cost_card_text"), "green")
  })
  
  #Despesas com vigilância
  output$surveillance_card <- renderValueBox({
    indicators_card("vigilancia", "R$", 2, 2, translate("surveillance_card_subtitle"), "aqua")
  })
  
  #Despesas com inseticida
  output$insecticide_card <- renderValueBox({
    indicators_card("inseticida", "R$", 2, 2, translate("insecticide_card_subtitle"), "aqua")
  })
  
  #Despesas com screening
  output$screening_card <- renderValueBox({
    indicators_card("screening", "R$", 2, 2, translate("screening_card_subtitle"), "aqua")
  })
  
  #Despesas com mosquiteiro
  output$bed_nets_card <- renderValueBox({
    indicators_card("mosquiteiro", "R$", 2, 2, translate("bed_nets_card_subtitle"), "aqua")
  })
  
  #Número de municípios que recebem incentivo (microscopista)
  output$incentive_municipality_absolute_card <- renderValueBox({
    number_municipalities <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(number = sum(incentivo != 0))
    
    information_cards(number_municipalities$number, translate("numbers_incentive_card_subtitle"), "yellow")
  })
  
  #Proporção de municípios que recebem incentivo (microscopista)
  output$incentive_municipality_proportion_card <- renderValueBox({
    proportion_municipalities <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(number = sum(incentivo != 0),
                                                                                                                         municipalities = sum(!is.na(munic))) 
    proportion_municipalities$proportion <- proportion_municipalities$number/proportion_municipalities$municipalities
    proportion <- paste(format(round(as.numeric(proportion_municipalities$proportion*100), 2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), "%")
    
    information_cards(proportion, translate("proportion_incentive_card_subtitle"), "yellow")
  })
  
  #Número de ACS
  output$quantitative_acs_card <- renderValueBox({
    indicators_card("acs", "", 0, 2, translate("acs_number_card"), "yellow")
  })
  
  #Número de microscopistas
  output$quantitative_microscopist_card <- renderValueBox({
    indicators_card("microscopista", "", 0, 2, translate("microscopist_number_card"), "yellow")
  })
  
  #Despesas com ACS
  output$expenditures_acs_card <- renderValueBox({
    indicators_card("salario_acs", "R$", 2, 2, translate("acs_expenditures_card"), "yellow")
  })
  
  #Despesas com microscopistas
  output$expenditures_microscopist_card <- renderValueBox({
    indicators_card("salario_microscopista", "R$", 2, 2, translate("microscopist_expenditures_card"), "yellow")
  })
  
  #Incentivos federais
  output$incentives_card <- renderValueBox({
    indicators_card("incentivo", "R$", 2, 2, translate("incentive_card"), "yellow")
  })
  
  #Despesas com diagnóstico e tratamento (Aba "Despesas totais" - UF/municípios) 
  output$diagnostic_treatment_total_uf_mun <- renderValueBox({
    indicators_card("gasto_diagtrat_total", "R$", 2, 2, translate("total_diagnostic_treatment_title"), "red")
  })
  
  #Despesas com vigilância e controle (Aba "Despesas totais" - UF/municípios) 
  output$surveillance_control_total_uf_mun <- renderValueBox({
    indicators_card("gasto_total_vigil_control", "R$", 2, 2, translate("total_surveillance_control_title"), "red")    
  })

  #Despesas com recursos humanos (Aba "Despesas totais" - UF/municípios)   
  output$human_resources_total_uf_mun <- renderValueBox({
    indicators_card("total_rh", "R$", 2, 2, translate("human_resources_tab_title"), "red")    
  })
  
  #Despesas com diagnóstico e tratamento (Aba "Despesas totais" - Região amazônica) 
  output$diagnostic_treatment_total_amazonic_region <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input) %>% summarise(total = sum(gasto_diagtrat_total))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
           )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("total_diagnostic_treatment_title"), "red")
  })

  #Despesas com vigilância e controle (Aba "Despesas totais" - Região amazônica) 
  output$surveillance_control_amazonic_region <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input) %>% summarise(total = sum(gasto_total_vigil_control))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("total_surveillance_control_title"), "red")
  })

  #Despesas com recursos humanos (Aba "Despesas totais" - UF/municípios)   
  output$human_resources_total_amazonic_region <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input) %>% summarise(total = sum(total_rh))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("human_resources_tab_title"), "red")
  })
  
  #Despesas com diagnóstico e tratamento (Aba "Despesas totais" - Faixa de IPA) 
  output$diagnostic_treatment_total_ipa_group <- renderValueBox({
    switch(ipa_group_total_choices(),
           "Zero (0)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(total = sum(gasto_diagtrat_total))
             population <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(episodes = sum(notificacoes))
           },
           "Muito baixo (<1)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(total = sum(gasto_diagtrat_total))
             population <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(episodes = sum(notificacoes))
           },
           "Baixo (>=1 e <50)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(total = sum(gasto_diagtrat_total))
             population <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(episodes = sum(notificacoes))
           },
           "Alto (>=50)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(total = sum(gasto_diagtrat_total))
             population <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(episodes = sum(notificacoes))
           }
           )
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("total_diagnostic_treatment_title"), "red")
    
  })
  
  #Despesas com vigilância e controle (Aba "Despesas totais" - Faixa de IPA) 
  output$surveillance_control_total_ipa_group <- renderValueBox({
    switch(ipa_group_total_choices(),
           "Zero (0)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(total = sum(gasto_total_vigil_control))
             population <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(episodes = sum(notificacoes))
           },
           "Muito baixo (<1)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(total = sum(gasto_total_vigil_control))
             population <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(episodes = sum(notificacoes))
           },
           "Baixo (>=1 e <50)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(total = sum(gasto_total_vigil_control))
             population <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(episodes = sum(notificacoes))
           },
           "Alto (>=50)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(total = sum(gasto_total_vigil_control))
             population <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(episodes = sum(notificacoes))
           }
    )
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("total_surveillance_control_title"), "red")
    
  })
  
  #Despesas com recursos humanos (Aba "Despesas totais" - Faixa de IPA) 
  output$human_resources_total_ipa_group <- renderValueBox({
    switch(ipa_group_total_choices(),
           "Zero (0)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(total = sum(total_rh))
             population <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(episodes = sum(notificacoes))
           },
           "Muito baixo (<1)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(total = sum(total_rh))
             population <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(episodes = sum(notificacoes))
           },
           "Baixo (>=1 e <50)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(total = sum(total_rh))
             population <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(episodes = sum(notificacoes))
           },
           "Alto (>=50)" = {
             expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(total = sum(total_rh))
             population <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(population = sum(pop))
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(episodes = sum(notificacoes))
           }
    )
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("human_resources_tab_title"), "red")
    
  })
  
  #Despesas totais (IPA Zero)
  output$zero_api_total <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(total = sum(despesa_total))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("zero_api_subtitle_card"), "red")
  })

  #Despesas totais (IPA muito baixo)
  output$very_low_api_total <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(total = sum(despesa_total))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>0 & IPA<1) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("very_low_api_subtitle_card"), "red")
  })
  
  #Despesas totais (IPA baixo)
  output$low_api_total <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(total = sum(despesa_total))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("low_api_subtitle_card"), "red")
  })
  
  #Despesas totais (Alto IPA)
  output$high_api_total <- renderValueBox({
    expenditure <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(total = sum(despesa_total))
    switch(indicator_applied(),
           "Valores absolutos" = {
             paste_post <- ""
           },
           "Per capita" = {
             population <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(population = sum(pop))
             expenditure$total <- expenditure$total/population$population
             paste_post <- "per capita"
           },
           "Por notificação" = {
             episodes <- base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(episodes = sum(notificacoes))
             expenditure$total <- expenditure$total/episodes$episodes
             paste_post <- translate("episode_card_graph")
           }
           
    )
    
    final_value <- paste("R$", format(round(as.numeric(expenditure$total),2), nsmall = 2, big.mark = ".", decimal.mark = ",", preserve.width = "none"), paste_post)
    information_cards(final_value, translate("high_api_subtitle_card"), "red")
  })
  
#--Gráficos--------------------------------  
    
  #Notificações
  output$notifications_plot <- renderPlotly({
    if(input$aggregation_input > 0){
      discarted_cases <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(casos_descartados), na.rm = TRUE)
      confirmed_cases <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(casos_confirmados), na.rm = TRUE)
    } else{
      req(input$city_input)
      
      discarted_cases <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_descartados)
      confirmed_cases <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_confirmados)    
    }
    
    data_plot <- data.frame(cbind(translate("notifications_nature"),rbind(discarted_cases, confirmed_cases)))
    colnames(data_plot) <- c("categories", "values")
    
    text <- paste(prettyNum(as.numeric(format(round(as.numeric(data_plot$values), 0), nsmall = 0)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("casos"))
    colors <- c('rgb(0,0,139)','rgb(102,205,0)')
    pie_chart(data_plot, data_plot$categories, data_plot$values, text, colors)
  })

  #Natureza dos casos
  output$nature_plot <- renderPlotly({
    if(input$aggregation_input > 0){
      mild_cases <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(casos_leves), na.rm = TRUE)
      severe_cases <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(casos_severos), na.rm = TRUE)
    } else{
      req(input$city_input)
      
      mild_cases <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_leves)
      severe_cases <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_severos)    
    }
    
    data_plot <- data.frame(cbind(translate("episodes_nature"),rbind(mild_cases, severe_cases)))
    colnames(data_plot) <- c("categories", "values")
    
    text <- paste(prettyNum(as.numeric(format(round(as.numeric(data_plot$values), 0), nsmall = 0)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("casos"))
    colors <- c('rgb(0,0,139)','rgb(102,205,0)')
    pie_chart(data_plot, data_plot$categories, data_plot$values, text, colors)
  })
  
  #Distribuição dos casos
  output$pyramid_plot <- renderPlotly({
    ages <- c("0-05", "05-10", "10-15", "15-20", "20-25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-55", "55-60", "60-65", "65-70", "70-75", "75-80", "80-85", "85-90", "90-95", "95<")
    male <- translate("Masculino")
    female <- translate("Feminino")
    genders <- rep(c(male, female), each = 20)
    
    if(input$aggregation_input > 0){
      episodes_male <- (colSums(base_dados %>% filter(estado == input$uf_input & ano == input$year_input) %>% select('(-Inf,5]_M','(5,10]_M','(10,15]_M','(15,20]_M', '(20,25]_M', '(25,30]_M', '(30,35]_M','(35,40]_M', '(40,45]_M', '(45,50]_M', '(50,55]_M', '(55,60]_M', '(60,65]_M', '(65,70]_M', '(70,75]_M', '(75,80]_M', '(80,85]_M', '(85,90]_M', '(90,95]_M', '(95, Inf]_M'), na.rm = TRUE)*(-1))
      episodes_female <- colSums(base_dados %>% filter(estado == input$uf_input & ano == input$year_input) %>% select('(-Inf,5]_F','(5,10]_F','(10,15]_F','(15,20]_F', '(20,25]_F', '(25,30]_F', '(30,35]_F','(35,40]_F', '(40,45]_F', '(45,50]_F', '(50,55]_F', '(55,60]_F', '(60,65]_F', '(65,70]_F', '(70,75]_F', '(75,80]_F', '(80,85]_F', '(85,90]_F', '(90,95]_F', '(95, Inf]_F'), na.rm = TRUE)
    } else {
      req(input$city_input)
      
      episodes_male <- (colSums(base_dados %>% filter(estado == input$uf_input & ano == input$year_input & nome_municipio==input$city_input) %>% select('(-Inf,5]_M','(5,10]_M','(10,15]_M','(15,20]_M', '(20,25]_M', '(25,30]_M', '(30,35]_M','(35,40]_M', '(40,45]_M', '(45,50]_M', '(50,55]_M', '(55,60]_M', '(60,65]_M', '(65,70]_M', '(70,75]_M', '(75,80]_M', '(80,85]_M', '(85,90]_M', '(90,95]_M', '(95, Inf]_M'), na.rm = TRUE)*(-1))
      episodes_female <- colSums(base_dados %>% filter(estado == input$uf_input & ano == input$year_input & nome_municipio==input$city_input) %>% select('(-Inf,5]_F','(5,10]_F','(10,15]_F','(15,20]_F', '(20,25]_F', '(25,30]_F', '(30,35]_F','(35,40]_F', '(40,45]_F', '(45,50]_F', '(50,55]_F', '(55,60]_F', '(60,65]_F', '(65,70]_F', '(70,75]_F', '(75,80]_F', '(80,85]_F', '(85,90]_F', '(90,95]_F', '(95, Inf]_F'), na.rm = TRUE)
    }
    
    episodes_total <- cbind(episodes_female, episodes_male)
    
    age_pyramid <- data.frame(ages, genders, episodes_total)
    
    age_pyramid %>%
      plot_ly(x = ~episodes_total, y =~ages, color = genders, colors = c("chartreuse3", "darkblue")) %>%
      add_bars(orientation = 'h', hovertemplate = ~paste(prettyNum(as.numeric(format(round(as.numeric(abs(as.numeric(episodes_total))), 2), nsmall = 2)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("casos"))) %>%
      layout(bargap = 0.1, barmode = 'overlay',
             yaxis = list(title = translate("age_group")),
             xaxis = list(title = translate("Casos confirmados"))) %>%
      toWebGL()
  })
  
  output$gender_plot <- renderPlotly({
    if(input$aggregation_input > 0){
      male_episodes <- sum(base_dados %>% filter(estado == input$uf_input & ano == input$year_input) %>% select('(-Inf,5]_M','(5,10]_M','(10,15]_M','(15,20]_M', '(20,25]_M', '(25,30]_M', '(30,35]_M','(35,40]_M', '(40,45]_M', '(45,50]_M', '(50,55]_M', '(55,60]_M', '(60,65]_M', '(65,70]_M', '(70,75]_M', '(75,80]_M', '(80,85]_M', '(85,90]_M', '(90,95]_M', '(95, Inf]_M'), na.rm = TRUE)
      female_episodes <- sum(base_dados %>% filter(estado == input$uf_input & ano == input$year_input) %>% select('(-Inf,5]_F','(5,10]_F','(10,15]_F','(15,20]_F', '(20,25]_F', '(25,30]_F', '(30,35]_F','(35,40]_F', '(40,45]_F', '(45,50]_F', '(50,55]_F', '(55,60]_F', '(60,65]_F', '(65,70]_F', '(70,75]_F', '(75,80]_F', '(80,85]_F', '(85,90]_F', '(90,95]_F', '(95, Inf]_F'), na.rm = TRUE)
    } else {
      req(input$city_input)
      
      male_episodes <- sum(base_dados %>% filter(estado == input$uf_input & ano == input$year_input & nome_municipio==input$city_input) %>% select('(-Inf,5]_M','(5,10]_M','(10,15]_M','(15,20]_M', '(20,25]_M', '(25,30]_M', '(30,35]_M','(35,40]_M', '(40,45]_M', '(45,50]_M', '(50,55]_M', '(55,60]_M', '(60,65]_M', '(65,70]_M', '(70,75]_M', '(75,80]_M', '(80,85]_M', '(85,90]_M', '(90,95]_M', '(95, Inf]_M'), na.rm = TRUE)
      female_episodes <- sum(base_dados %>% filter(estado == input$uf_input & ano == input$year_input & nome_municipio==input$city_input) %>% select('(-Inf,5]_F','(5,10]_F','(10,15]_F','(15,20]_F', '(20,25]_F', '(25,30]_F', '(30,35]_F','(35,40]_F', '(40,45]_F', '(45,50]_F', '(50,55]_F', '(55,60]_F', '(60,65]_F', '(65,70]_F', '(70,75]_F', '(75,80]_F', '(80,85]_F', '(85,90]_F', '(90,95]_F', '(95, Inf]_F'), na.rm = TRUE)
    }
    
    data_plot <-data.frame(cbind(translate("genders"), rbind(female_episodes, male_episodes)))
    colnames(data_plot) <-c("categories", "values")
    
    text <- paste(prettyNum(as.numeric(format(round(as.numeric(data_plot$values), 2), nsmall = 2)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("casos"))
    colors <- c('rgb(0,0,139)','rgb(102,205,0)')
    
    pie_chart(data_plot, data_plot$categories, data_plot$values, text, colors)
  })
  
  output$age_plot <- renderPlotly({
      if(input$aggregation_input > 0){
        zeroACinco <-sum(base_dados$'(-Inf,5]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(-Inf,5]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        cincoADez <-sum(base_dados$'(5,10]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(5,10]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        dezAQuinze <-sum(base_dados$'(10,15]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(10,15]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        quizeAVinte <-sum(base_dados$'(15,20]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(15,20]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        vinteAVinteCinco <-sum(base_dados$'(20,25]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(20,25]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        vinteCincoATrinta <-sum(base_dados$'(25,30]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(25,30]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        trintaATrintaCinco <-sum(base_dados$'(30,35]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(30,35]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        trintaCincoAQuarenta <-sum(base_dados$'(35,40]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(35,40]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        quarentaAQuarentaCinco <-sum(base_dados$'(40,45]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(40,45]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        quarentaCincoACinquenta <-sum(base_dados$'(45,50]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(45,50]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        cinquentaACinquentaCinco <-sum(base_dados$'(50,55]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(50,55]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        cinquentaCincoASessenta <-sum(base_dados$'(55,60]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(55,60]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        sessentaASessentaCinco <-sum(base_dados$'(60,65]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(60,65]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        sessentaCincoASetenta <-sum(base_dados$'(65,70]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(65,70]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        setentaASetentaCinco <-sum(base_dados$'(70,75]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(70,75]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        setentaCincoAOitenta <-sum(base_dados$'(75,80]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(75,80]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        oitentaAOitentaCinco <-sum(base_dados$'(80,85]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(80,85]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        oitentaCincoANoventa <-sum(base_dados$'(85,90]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(85,90]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        noventaANoventaCinco <-sum(base_dados$'(90,95]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(90,95]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
        noventaCincoMais <-sum(base_dados$'(95, Inf]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], base_dados$'(95, Inf]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input)], na.rm = TRUE)
      } else {
        req(input$city_input)
        
        zeroACinco <-sum(base_dados$'(-Inf,5]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(-Inf,5]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        cincoADez <-sum(base_dados$'(5,10]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(5,10]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        dezAQuinze <-sum(base_dados$'(10,15]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(10,15]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        quizeAVinte <-sum(base_dados$'(15,20]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(15,20]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        vinteAVinteCinco <-sum(base_dados$'(20,25]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(20,25]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        vinteCincoATrinta <-sum(base_dados$'(25,30]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(25,30]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        trintaATrintaCinco <-sum(base_dados$'(30,35]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(30,35]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        trintaCincoAQuarenta <-sum(base_dados$'(35,40]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(35,40]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        quarentaAQuarentaCinco <-sum(base_dados$'(40,45]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(40,45]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        quarentaCincoACinquenta <-sum(base_dados$'(45,50]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(45,50]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        cinquentaACinquentaCinco <-sum(base_dados$'(50,55]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(50,55]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        cinquentaCincoASessenta <-sum(base_dados$'(55,60]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(55,60]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        sessentaASessentaCinco <-sum(base_dados$'(60,65]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(60,65]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        sessentaCincoASetenta <-sum(base_dados$'(65,70]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(65,70]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        setentaASetentaCinco <-sum(base_dados$'(70,75]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(70,75]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        setentaCincoAOitenta <-sum(base_dados$'(75,80]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(75,80]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        oitentaAOitentaCinco <-sum(base_dados$'(80,85]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(80,85]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        oitentaCincoANoventa <-sum(base_dados$'(85,90]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(85,90]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        noventaANoventaCinco <-sum(base_dados$'(90,95]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(90,95]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE)
        noventaCincoMais <-sum(base_dados$'(95, Inf]_F'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], base_dados$'(95, Inf]_M'[which(base_dados$ano==input$year_input & base_dados$estado==input$uf_input & base_dados$nome_municipio==input$city_input)], na.rm = TRUE) 
      }
      age_groups <- c("0-05", "05-10", "10-15", "15-20", "20-25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-55", "55-60", "60-65", "65-70", "70-75", "75-80", "80-85", "85-90", "90-95", "95<")
      data_plot <- data.frame(cbind(age_groups,(rbind(zeroACinco,cincoADez,dezAQuinze,quizeAVinte,vinteAVinteCinco,vinteCincoATrinta,trintaATrintaCinco,trintaCincoAQuarenta,quarentaAQuarentaCinco,quarentaCincoACinquenta,cinquentaACinquentaCinco,cinquentaCincoASessenta,sessentaASessentaCinco,sessentaCincoASetenta,setentaASetentaCinco,setentaCincoAOitenta,oitentaAOitentaCinco,oitentaCincoANoventa,noventaANoventaCinco,noventaCincoMais))))
      colnames(data_plot) <- c("groups", "episodes")
      
      plot_ly(data_plot, x = ~as.factor(groups), y = ~as.numeric(episodes), type = "bar", hovertemplate = paste(prettyNum(as.numeric(format(round(as.numeric(data_plot$episodes), 2), nsmall = 2)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("casos")), name = paste(data_plot$groups, translate("anos")),
              marker = list(color = c("rgb(0,0,139)","rgb(0,0,139)","rgb(0,0,139)","rgb(0,0,139)","rgb(0,0,139)","rgb(85,107,47)","rgb(85,107,47)","rgb(85,107,47)","rgb(85,107,47)","rgb(85,107,47)","rgb(238,173,14)","rgb(238,173,14)","rgb(238,173,14)","rgb(238,173,14)","rgb(238,173,14)","rgb(102,205,0)","rgb(102,205,0)","rgb(102,205,0)","rgb(102,205,0)", "rgb(102,205,0)"))) %>%
        layout(xaxis = list(title = translate("age_group")),
               yaxis = list (title = translate("Casos")),
               showlegend = FALSE) %>%
        toWebGL()
    })
  
  #Mapa de incidência
  output$map_plot <- renderLeaflet({
    data_map <- data_map_formation()
    map_plotting(data_map)
  })
  
  #Tipo de parasita
  output$parasite_plot <- renderPlotly({
    if(parasite_choice() == "Tendência"||parasite_choice() == "Trend"){
      if(input$aggregation_input > 0){
        parasite <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(vivax = sum(casos_vivax),
                                                                                                    falciparum = sum(casos_falciparum),
                                                                                                    outros = sum(casos_outros))
      } else{
        req(input$city_input)
        
        parasite <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(vivax = sum(casos_vivax),
                                                                                                                                         falciparum = sum(casos_falciparum),
                                                                                                                                         outros = sum(casos_outros))      
      }
      
      line_graph(parasite, translate("parasites"), translate("ano"), translate("parasite_axis"), "",0,translate("casos"))
    } else{
      if(input$aggregation_input >0){
        parasite <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(vivax = sum(casos_vivax),
                                                                                                  falciparum = sum(casos_falciparum),
                                                                                                  outros = sum(casos_outros)))
        

        
      } else{
        req(input$city_input)
        
        parasite <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% summarise(vivax = sum(casos_vivax),
                                                                                                                                                   falciparum = sum(casos_falciparum),
                                                                                                                                                   outros = sum(casos_outros)))        
      }
      
      data_plot <- data.frame(cbind(translate("parasites"),parasite))
      colnames(data_plot) <- c("categories", "values")
      
      text <- paste(prettyNum(as.numeric(format(round(as.numeric(data_plot$values), 0), nsmall = 0)), big.mark = ".", decimal.mark = ",", preserve.width = "none"), translate("casos"))
      colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)")
      
      pie_chart(data_plot, data_plot$categories, data_plot$values, text, colors)
      
    }
    

  })
  
  #IPA
  output$ipa_plot <- renderPlotly({
    if(input$aggregation_input > 0){

      data_ipa <- base_ipa_uf[,c("ano", input$uf_input)]
      
      if(ipa_comparison() == 0){
        line_graph(data_ipa, input$uf_input, translate("ano"), translate("ipa_title"), translate("ipa_graph"), 2, "")
      } else{
        if(length(ufs_ipa_comparison()) == 0){
          line_graph(data_ipa, input$uf_input, translate("ano"), translate("ipa_title"), translate("ipa_graph"), 2, "")
        } else{
          for(i in 1:length(ufs_ipa_comparison())){
            df_temp <- base_ipa_uf[,c("ano", ufs_ipa_comparison()[i])]
            data_ipa <- merge(data_ipa, df_temp, by = "ano")
            name_vector <- colnames(data_ipa)
            name_vector <- name_vector[-1]
          }
          line_graph(data_ipa, name_vector, translate("ano"), translate("ipa_title"), translate("ipa_graph"), 2, "")          
        } 
      }
    } else{
      if(ipa_comparison() == 0){
        data_ipa <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, IPA) %>% arrange(ano)
        line_graph(data_ipa, input$city_input, translate("ano"), translate("ipa_title"), translate("ipa_graph"), 2, "")        
      } else{
        comparison_cities_absolute_value_line_graph("IPA", translate("ipa_title"), translate("ipa_graph"), cities_ipa_comparison$comparison_vector(), cities_ipa_comparison$choice())
      }

    }
    
  })

  #Despesas totais com diagnóstico e tratamento
  output$total_diagnostic_treatment_plot <- renderPlotly({
    if(total_diagnostic_treatment_comparison() == 0){
      if(total_diagnostic_treatment_choice() == "Tendência"||total_diagnostic_treatment_choice() == "Trend"){
        if(input$aggregation_input >0){
          data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(tests = sum(gasto_exame_total),
                                                                                                       medicines = sum(medicamento_total),
                                                                                                       hospitalizations = sum(hospitalizacoes_gasto)) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(gasto_diagtrat_total)) %>% arrange(ano)
          population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
        } else{
          data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, gasto_exame_total, medicamento_total, hospitalizacoes_gasto) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, gasto_diagtrat_total) %>% arrange(ano)
          colnames(total_plot) <- c("ano", "total")
          
          population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(population = pop) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(episodes = notificacoes) %>% arrange(ano)       
        }
        
        stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_diagnostic_treatment_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_diagnostic_treatment_yaxis"), indicator_applied())
      } else{
        if(input$aggregation_input >0){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(tests = sum(gasto_exame_total),
                                                                                                              medicines = sum(medicamento_total),
                                                                                                              hospitalizations = sum(hospitalizacoes_gasto)))
          
          
          population <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)
          episodes <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)
        } else{
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(gasto_exame_total, medicamento_total, hospitalizacoes_gasto))
          
          population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
          episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)      
        }
        
        data_plot <- data.frame(cbind(translate("total_diagnostic_treatment_names"), values))
        colnames(data_plot) <- c("categories", "values")
        colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)")
        
        pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, indicator_applied())
        
      }
      
    } else{
      comparison_function(total_diagnostic_treatment_choice(), "gasto_diagtrat_total", translate("uf"), translate("city"), translate("total_diagnostic_treatment_yaxis"), "R$", 2, "", ufs_total_diagnostic_treatment_comparison(), cities_total_diagnostic_treatment_comparison$comparison_vector(), cities_total_diagnostic_treatment_comparison$choice(), indicator_applied())
    }
  


  })

  #Testes (quantitativo)
  output$tests_quantitative_plot <- renderPlotly({
    tests_plot_function("exame_gota_espessa", "exame_teste_rapido", "exame_total", "exame_gota_confirmado", "exame_rapido_confirmado", "exame_gota_vivax", "exame_rapido_vivax", "casos_vivax", "exame_gota_falciparum", "exame_rapido_falciparum", "casos_falciparum", "exame_gota_outros", "exame_rapido_outros", "casos_outros",  translate("tests_names"), "", 2, translate("tests"), translate("total_tests"),  translate("ano"), translate("tests_quantitative_yaxis"), indicator_applied())

  })
  
  #Testes (despesas)
  output$tests_expenditures_plot <- renderPlotly({
     if(tests_comparison() == 0){
      tests_plot_function("gasto_gota_espessa", "gasto_teste_rapido", "gasto_exame_total", "gasto_gota_confirmado", "gasto_rapido_confirmado", "custo_gota_vivax", "custo_rapido_vivax", "custo_total_vivax", "custo_gota_falciparum", "custo_rapido_falciparum", "custo_total_falciparum", "custo_gota_outros", "custo_rapido_outros", "custo_total_outros",  translate("tests_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("tests_expenditure_yaxis"), indicator_applied())
    } else{
      if(test_type_chosen() == "Exames totais"){
        comparison_function(tests_choice(), "gasto_exame_total", translate("uf"), translate("city"),translate("tests_expenditure_yaxis"), "R$", 2, "", ufs_tests_comparison(), cities_tests_comparison$comparison_vector(), cities_tests_comparison$choice(), indicator_applied())
      } else{
       switch(parasite_type_chosen(),
              "Todos os tipos" ={
                comparison_function(tests_choice(), "gasto_total_confirmado", translate("uf"), translate("city"),translate("tests_expenditure_yaxis"), "R$", 2, "", ufs_tests_comparison(), cities_tests_comparison$comparison_vector(), cities_tests_comparison$choice(), indicator_applied())
              },
              "Vivax" = {
                comparison_function(tests_choice(), "custo_total_vivax", translate("uf"), translate("city"),translate("tests_expenditure_yaxis"), "R$", 2, "", ufs_tests_comparison(), cities_tests_comparison$comparison_vector(), cities_tests_comparison$choice(), indicator_applied())
              },
              "Falciparum" = {
                comparison_function(tests_choice(), "custo_total_falciparum", translate("uf"), translate("city"),translate("tests_expenditure_yaxis"), "R$", 2, "", ufs_tests_comparison(), cities_tests_comparison$comparison_vector(), cities_tests_comparison$choice(), indicator_applied())
              },
              "Outros" = {
                comparison_function(tests_choice(), "custo_total_outros", translate("uf"), translate("city"),translate("tests_expenditure_yaxis"), "R$", 2, "", ufs_tests_comparison(), cities_tests_comparison$comparison_vector(), cities_tests_comparison$choice(), indicator_applied())
              }
         
       )
     }

      
    }
  })
  
  #Despesas com medicamentos (todos)
  output$total_medicines_plot <- renderPlotly({
    if(total_medicines_comparison() == 0){
      if(total_medicines_choice() == "Tendência"||total_medicines_choice() == "Trend"){
        if(input$aggregation_input > 0){
          data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(scheme_1 = sum(medicamento_esq_1),
                                                                                                       scheme_2 = sum(medicamento_esq_2),
                                                                                                       scheme_3 = sum(medicamento_esq_3),
                                                                                                       scheme_4 = sum(medicamento_esq_4),
                                                                                                       scheme_5 = sum(medicamento_esq_5)) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(medicamento_total)) %>% arrange(ano)
          population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
        } else{
          data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, medicamento_esq_1, medicamento_esq_2, medicamento_esq_3, medicamento_esq_4, medicamento_esq_5) %>% arrange(ano)
          total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, medicamento_total) %>% arrange(ano)
          colnames(total_plot) <- c("ano", "total")
          population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(population = pop) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(episodes = notificacoes) %>% arrange(ano) 
        }
        
        stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_medicines_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_medicines_yaxis"), total_medicines_indicator_applied())
      } else{
        if(input$aggregation_input > 0){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(scheme_1 = sum(medicamento_esq_1),
                                                                                                       scheme_2 = sum(medicamento_esq_2),
                                                                                                       scheme_3 = sum(medicamento_esq_3),
                                                                                                       scheme_4 = sum(medicamento_esq_4),
                                                                                                       scheme_5 = sum(medicamento_esq_5)))
          
          population <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)
          episodes <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)
        } else{
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(medicamento_esq_1, medicamento_esq_2, medicamento_esq_3, medicamento_esq_4, medicamento_esq_5))
          population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
          episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
        }
        data_plot <- data.frame(cbind(translate("total_medicines_names"), values))
        colnames(data_plot) <- c("categories", "values")
        colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)", "rgb(238,173,14)", "rgb(176,196,222)")
        
        pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, total_medicines_indicator_applied())
      }
    } else{
      comparison_function(total_medicines_choice(), "medicamento_total", translate("uf"), translate("city"), translate("total_medicines_yaxis"), "R$", 2, "", ufs_total_medicine_comparison(), cities_total_medicine_selection$comparison_vector(), cities_total_medicine_selection$choice(), total_medicines_indicator_applied())
    }
  })
 
  #Despesas com medicamentos (Vivax)
  output$vivax_medicines_plot <- renderPlotly({
    medicine_scheme_plot(vivax_medicines_comparison(), vivax_choice(), medicines_indicator_applied(), "medicamento_esq_1", "casos_vivax", translate("scheme_1"), translate("vivax_medicines_yaxis"), ufs_vivax_comparison(), cities_vivax_selection$comparison_vector(), cities_vivax_selection$choice())
  })
  
  #Despesas com medicamentos (Falciparum)
  output$falciparum_medicines_plot <- renderPlotly({
    medicine_scheme_plot(falciparum_medicines_comparison(), falciparum_choice(), medicines_indicator_applied(), "medicamento_esq_2", "casos_falciparum", translate("scheme_2"), translate("falciparum_medicines_yaxis"), ufs_falciparum_comparison(), cities_falciparum_selection$comparison_vector(), cities_falciparum_selection$choice())
  })
  
  #Despesas com medicamentos (Outros)
  output$others_medicines_plot <- renderPlotly({
    medicine_scheme_plot(others_medicines_comparison(), others_choice(), medicines_indicator_applied(), "medicamento_esq_3_4", "casos_outros", translate("scheme_3_4"), translate("others_medicines_yaxis"), ufs_others_comparison(), cities_others_selection$comparison_vector(), cities_others_selection$choice())
  })
  
  #Despesas com medicamentos (Graves)
  output$severe_medicines_plot <- renderPlotly({
    medicine_scheme_plot(severe_medicines_comparison(), severe_choice(), medicines_indicator_applied(), "medicamento_esq_5", "casos_severos", translate("scheme_5"), translate("severe_medicines_yaxis"), ufs_severe_comparison(), cities_severe_selection$comparison_vector(), cities_severe_selection$choice())
  })
  
  #Hospitalizações (quantitativo)
  output$quantitative_hospitalization_plot <- renderPlotly({
    if(input$aggregation_input > 0){
      data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(hospitalizations = sum(hospitalizacoes_n)) %>% arrange(ano) 
      switch(quantitative_hospitalization_indicators_applied(),
             "Valores absolutos" = {
               hover_pre <- ""
               digits <- 0
               hover_post <- ""
             },
             "Per capita" = {
               population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               data_plot$hospitalizations <- data_plot$hospitalizations/population$population
               hover_pre <- ""
               digits <- 2
               hover_post <- "per capita"
             },
             "Por notificação" = {
               episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               data_plot$hospitalizations <- data_plot$hospitalizations/episodes$episodes
               hover_pre <- ""
               digits <- 2
               hover_post <-translate("episode_card_graph")
             }
             )
    } else{
      data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_n) %>% arrange(ano)
      switch(quantitative_hospitalization_indicators_applied(),
             "Valores absolutos" = {
               hover_pre <- ""
               digits <- 0
               hover_post <- ""
             },
             "Per capita" = {
               population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
               data_plot$hospitalizacoes_n <- data_plot$hospitalizacoes_n/population$pop
               hover_pre <- ""
               digits <- 2
               hover_post <- "per capita"
             },
             "Por notificação" = {
               episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
               data_plot$hospitalizacoes_n <- data_plot$hospitalizacoes_n/episodes$notificacoes
               hover_pre <- ""
               digits <- 2
               hover_post <-translate("episode_card_graph")
             }
      )      
    }
    line_graph(data_plot, translate("Hospitalizações"), translate("ano"), translate("quantitative_hospitalization_yaxis"), hover_pre, digits, hover_post)
  })
  
  #Hospitalizações (duração)
  output$length_hospitalization_plot <- renderPlotly({
    if(input$aggregation_input > 0){
     hospitalization_length <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(length = sum(hospitalizacoes_dias)/sum(hospitalizacoes_n)) %>% arrange(ano)
     
     y_axis <- translate("length_hospitalization_state_yaxis")
     digits <- 2
    } else{
      switch(length_hospitalization_indicators_applied(),
             "Valores absolutos" = {
               hospitalization_length <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_dias) %>% arrange(ano)
               y_axis <- translate("length_hospitalization_city_yaxis")
               digits <- 0
             },
             "Média" = {
               hospitalization_length <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_dias_m) %>% arrange(ano)
               y_axis <- translate("length_hospitalization_average_city_yaxis")
               digits <- 2
             }
      )
    }
    line_graph(hospitalization_length, translate("length"), translate("ano"), y_axis, "", digits, translate("days"))
  })
  
  #Hospitalizações (despesa)
  output$expenditures_hospitalization_plot <- renderPlotly({
    if(expenditures_hospitalization_comparison() == 0){
      if(input$aggregation_input > 0){
        data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(hospitalization = sum(hospitalizacoes_gasto)) %>% arrange(ano)
        switch(expenditures_hospitalization_indicators_applied(),
               "Valores absolutos" = {
                 hover_post <- ""
               },
               "Média" = {
                 hospitalizations_number <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(number = sum(hospitalizacoes_n)) %>% arrange(ano)
                 data_plot$hospitalization <- data_plot$hospitalization/hospitalizations_number$number
                 hover_post <- ""
               },
               "Per capita" = {
                 population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
                 data_plot$hospitalization <- data_plot$hospitalization/population$population
                 hover_post <- "per capita"
               },
               "Por notificação" = {
                 episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
                 data_plot$hospitalization <- data_plot$hospitalization/episodes$episodes
                 hover_post <- translate("episode_card_graph")
               }
               )
      } else{
        switch(expenditures_hospitalization_indicators_applied(),
               "Valores absolutos" = {
                 data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_gasto) %>% arrange(ano)
                 hover_post <- ""
               },
               "Média" = {
                 data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_gasto_m) %>% arrange(ano)
                 hover_post <- ""
               },
               "Per capita" = {
                 data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_gasto) %>% arrange(ano)
                 population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
                 data_plot$hospitalizacoes_gasto <- data_plot$hospitalizacoes_gasto/population$pop
                 hover_post <- "per capita"
               },
               "Por notificação" = {
                 data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, hospitalizacoes_gasto) %>% arrange(ano)
                 episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
                 data_plot$hospitalizacoes_gasto <- data_plot$hospitalizacoes_gasto/episodes$notificacoes
                 hover_post <- translate("episode_card_graph")
               }
        )        
      }
      line_graph(data_plot, translate("expenditures"), translate("ano"), translate("expenditures_hospitalization_yaxis"), "R$", 2, hover_post)
    } else{
      if(expenditures_hospitalization_indicators_applied() != "Média"){
        comparison_function(expenditures_hospitalization_choice(), "hospitalizacoes_gasto", translate("uf"), translate("city"), translate("expenditures_hospitalization_yaxis"), "R$", 2, "", ufs_hospitalization_comparison(), cities_hospitalization_selection$comparison_vector(), cities_hospitalization_selection$choice(), expenditures_hospitalization_indicators_applied())
      } else{
        average_comparison_function(expenditures_hospitalization_choice(), "hospitalizacoes_gasto", "hospitalizacoes_n", "hospitalizacoes_gasto_m", translate("uf"), translate("city"), translate("expenditures_hospitalization_yaxis"), "R$",  ufs_hospitalization_comparison(), cities_hospitalization_selection$comparison_vector(), cities_hospitalization_selection$choice())
      }
    }
  })

  #Despesas totais com vigilância e controle
  output$total_surveillance_control_plot <- renderPlotly({
    if(total_surveillance_control_comparison() == 0){
      if(total_surveillance_control_choice() == "Tendência"||total_surveillance_control_choice() == "Trend"){
        if(input$aggregation_input > 0){
          data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(surveillance = sum(vigilancia),
                                                                                                       insecticide = sum(inseticida),
                                                                                                       bed_net = sum(mosquiteiro),
                                                                                                       screening = sum(screening)) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(gasto_total_vigil_control)) %>% arrange(ano)
          population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
        } else{
          data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, vigilancia, inseticida, mosquiteiro, screening) %>% arrange(ano)
          total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, gasto_total_vigil_control) %>% arrange(ano)
          colnames(total_plot) <- c("ano", "total")
          
          population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(population = pop) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(episodes = notificacoes) %>% arrange(ano)
        }
        stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_surveillance_control_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_surveillance_control_yaxis"), indicator_applied())
      } else{
        if(input$aggregation_input > 0){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(surveillance = sum(vigilancia),
                                                                                                       insecticide = sum(inseticida),
                                                                                                       bed_net = sum(mosquiteiro),
                                                                                                       screening = sum(screening)))
          
          population <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)
          episodes <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)
        } else{
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(vigilancia, inseticida, mosquiteiro, screening))
          
          population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
          episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
        }
        data_plot <- data.frame(cbind(translate("total_surveillance_control_names"), values))
        colnames(data_plot) <- c("categories", "values")
        colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)", "rgb(176,196,222)")
        
        pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, indicator_applied())
      }
    } else{
      comparison_function(total_surveillance_control_choice(), "gasto_total_vigil_control", translate("uf"), translate("city"), translate("total_surveillance_control_yaxis"), "R$", 2, "", ufs_total_surveillance_control_comparison(), cities_total_surveillance_control_selection$comparison_vector(), cities_total_surveillance_control_selection$choice(), indicator_applied())
    }
  })
  
  #Despesas com vigilância
  output$surveillance_plot <- renderPlotly({
    if(surveillance_comparison() == 0){
      line_graph_indicators(indicator_applied(), "vigilancia", 2, translate("expenditures"), translate("ano"), translate("surveillance_yaxis"), "R$")
    } else{
      comparison_function(surveillance_choice(), "vigilancia", translate("uf"), translate("city"), translate("surveillance_yaxis"), "R$", 2, "", ufs_surveillance_comparison(), cities_surveillance_comparison$comparison_vector(), cities_surveillance_comparison$choice(), indicator_applied())
    }
  })
  
  #Screening (quantitativo)
  output$screening_quantitative_plot <- renderPlotly({
    line_graph_indicators(indicator_applied(), "bolsas", 0, translate("blood_bags"), translate("ano"), translate("screening_quantitative_yaxis"), "")
  })
  
  #Sreening (despesas)
  output$screening_expenditures_plot <- renderPlotly({
    if(screening_comparison() == 0){
      line_graph_indicators(indicator_applied(), "screening", 2, translate("expenditures"), translate("ano"), translate("screening_expenditures_yaxis"), "R$")
    } else{
      comparison_function(screening_choice(), "screening", translate("uf"), translate("city"), translate("screening_expenditures_yaxis"), "R$", 2, "", ufs_screening_comparison(), cities_screening_comparison$comparison_vector(), cities_screening_comparison$choice(), indicator_applied())
    }
  })
  
  #Despesas com inseticidas
  output$insecticide_plot <- renderPlotly({
    if(insecticide_comparison() == 0){
      line_graph_indicators(indicator_applied(), "inseticida", 2, translate("expenditures"), translate("ano"), translate("insecticide_yaxis"), "R$")
    } else{
      comparison_function(insecticide_choice(), "inseticida", translate("uf"), translate("city"), translate("insecticide_yaxis"), "R$", 2, "", ufs_insecticide_comparison(), cities_insecticide_comparison$comparison_vector(), cities_insecticide_comparison$choice(), indicator_applied())
    }
  })
  
  #Recursos humanos (quantitativo)
  output$human_resources_quantitative_plot <- renderPlotly({
    if(input$aggregation_input > 0){
      data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(acs = sum(acs),
                                                                                                   microscopista = sum(microscopista)) %>% arrange(ano)
      switch(indicator_applied(),
             "Valores absolutos" = {
               hover_post <- translate("workers")
               hover_digit <- 0
             },
             "Per capita" = {
               population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               data_plot$acs <- data_plot$acs/population$population
               data_plot$microscopista <- data_plot$microscopista/population$population
               hover_post <- translate("workers_per_capita")
               hover_digit <- 2
             },
             "Por notificação" = {
               episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               data_plot$acs <- data_plot$acs/episodes$episodes
               data_plot$microscopista <- data_plot$microscopista/episodes$episodes
               hover_post <- translate("workers_per_episode")
               hover_digit <- 2
             }
             
             )
    } else{
      data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, acs, microscopista) %>% arrange(ano)
      switch(indicator_applied(),
             "Valores absolutos" = {
               hover_post <- translate("workers")
               hover_digit <- 0
             },
             "Per capita" = {
               population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, pop) %>% arrange(ano)
               data_plot$acs <- data_plot$acs/population$pop
               data_plot$microscopista <- data_plot$microscopista/population$pop
               hover_post <- translate("workers_per_capita")
               hover_digit <- 2
             },
             "Por notificação" = {
               episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, notificacoes) %>% arrange(ano)
               data_plot$acs <- data_plot$acs/episodes$notificacoes
               data_plot$microscopista <- data_plot$microscopista/episodes$notificacoes
               hover_post <- translate("workers_per_episode")
               hover_digit <- 2
             }
             
      )
    }
    plot_ly(data_plot, x = ~ano, y = ~acs, name = translate("ACS"), type = "bar", hovertemplate = paste(format(round(as.numeric(data_plot$acs),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = 'rgb(0,0,139)')) %>%
      add_trace(y = ~microscopista, name = translate("Microscopist"), type = "bar", hovertemplate = paste(format(round(as.numeric(data_plot$microscopista),hover_digit), nsmall = hover_digit, big.mark = ".", decimal.mark = ",", preserve.width = "none"), hover_post), marker = list(color = 'rgb(102,205,0)'))%>%
      layout(xaxis = list(title = translate("ano")),
             yaxis = list(title = translate("quantitative_human_resources_yaxis")), 
             barmode = "group",
             hovermode = "x unified") %>%
      toWebGL()
  })
  
  #Recursos humanos (despesas)
  output$human_resources_expenditures_plot <- renderPlotly({
    if(human_resources_comparison() == 0){
      if(human_resources_choice() == "Tendência"||human_resources_choice() == "Trend"){
        if(input$aggregation_input > 0){
          data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(acs = sum(salario_acs),
                                                                                                       microscopista = sum(salario_microscopista),
                                                                                                       incentivo = sum(incentivo)) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(total_rh))
          population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
        } else{
          data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, salario_acs, salario_microscopista, incentivo) %>% arrange(ano)
          total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, total_rh) %>% arrange(ano)
          colnames(total_plot) <- c("ano", "total")
          
          population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(population = pop) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(episodes = notificacoes) %>% arrange(ano)
        }
        stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_human_resources_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_human_resources_yaxis"), indicator_applied())
      } else{
        if(input$aggregation_input > 0){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(acs = sum(salario_acs),
                                                                                                       microscopista = sum(salario_microscopista),
                                                                                                       incentivo = sum(incentivo)))
          
          population <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)
          episodes <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)
        } else{
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(salario_acs, salario_microscopista, incentivo))
          population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
          episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
        }
        data_plot <- data.frame(cbind(translate("total_human_resources_names"), values))
        colnames(data_plot) <- c("categories", "values")
        colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)")
        
        pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, indicator_applied())
      }
      
    } else{
      comparison_function(human_resources_choice(), "total_rh", translate("uf"), translate("city"), translate("total_human_resources_yaxis"), "R$", 2, "", ufs_human_resources_comparison(), cities_human_resources_comparison$comparison_vector(), cities_human_resources_comparison$choice(), indicator_applied())
    }
  })
  
  #Despesas totais (UF/município)
  output$total_expenditures_uf_mun_plot <- renderPlotly({
    if(total_expenditures_comparison() == 0){
      if(total_expenditures_choice() == "Tendência"||total_expenditures_choice() == "Trend"){
        if(input$aggregation_input > 0){
          data_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                       surveillance_control = sum(gasto_total_vigil_control),
                                                                                                       human_resources = sum(total_rh)) %>% arrange(ano)
          
          total_plot <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(total = sum(despesa_total))
          population <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
        } else{
          data_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, gasto_diagtrat_total, gasto_total_vigil_control, total_rh) %>% arrange(ano)
          total_plot <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% select(ano, despesa_total) %>% arrange(ano)
          colnames(total_plot) <- c("ano", "total")
          
          population <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(population = pop) %>% arrange(ano)
          episodes <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input) %>% group_by(ano) %>% summarise(episodes = notificacoes) %>% arrange(ano)
        }
        stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_expenditures_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_expenditures_yaxis"), indicator_applied())
      } else{
        if(input$aggregation_input > 0){
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                       surveillance_control = sum(gasto_total_vigil_control),
                                                                                                       human_resources = sum(total_rh)))
          
          population <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(pop),na.rm = TRUE)
          episodes <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(notificacoes),na.rm = TRUE)
        } else{
          values <- t(base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% select(gasto_diagtrat_total, gasto_total_vigil_control, total_rh))
          population <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
          episodes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
        }
        data_plot <- data.frame(cbind(translate("total_expenditures_names"), values))
        colnames(data_plot) <- c("categories", "values")
        colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)")
        
        pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, indicator_applied())
      } 
    } else{
      comparison_function(total_expenditures_choice(), "despesa_total", translate("uf"), translate("city"), translate("total_expenditures_yaxis"), "R$", 2, "", ufs_total_expenditure_comparison(), cities_total_expenditures_comparison$comparison_vector(), cities_total_expenditures_comparison$choice(), indicator_applied())
    }
  })
  
  #Despesas totais (região amazônica)
  output$total_expenditures_amazon_region_plot <- renderPlotly({
    if(total_expenditures_choice() == "Tendência"||total_expenditures_choice() == "Trend"){
      data_plot <- base_dados %>% group_by(ano) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                   surveillance_control = sum(gasto_total_vigil_control),
                                                                                                   human_resources = sum(total_rh)) %>% arrange(ano)
      
      total_plot <- base_dados %>% group_by(ano) %>% summarise(total = sum(despesa_total))
      population <- base_dados %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano) %>% arrange(ano)
      episodes <-  base_dados   %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
      
      stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_expenditures_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_expenditures_yaxis"), indicator_applied())
    } else{
      values <- t(base_dados %>% filter(ano == input$year_input) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                          surveillance_control = sum(gasto_total_vigil_control),
                                                                                                          human_resources = sum(total_rh)))
      
      population <- sum(base_dados %>% filter(ano == input$year_input) %>% pull(pop),na.rm = TRUE)
      episodes <- sum(base_dados %>% filter(ano == input$year_input) %>% pull(notificacoes),na.rm = TRUE) 
    
      data_plot <- data.frame(cbind(translate("total_expenditures_names"), values))
      colnames(data_plot) <- c("categories", "values")
      colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)")
      
      pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, indicator_applied())
      
      }

    
  })
  
  #Despesas totais (faixa de IPA)
  output$total_expenditures_ipa_group_plot <- renderPlotly({
    if(input$ipa_total_comparison == 0){
      if(total_expenditures_choice() == "Tendência"||total_expenditures_choice() == "Trend"){
        switch(ipa_group_total_choices(),
               "Zero (0)" = {
                 data_plot <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                            surveillance_control = sum(gasto_total_vigil_control),
                                                                                            human_resources = sum(total_rh)) %>% arrange(ano)
                 
                 total_plot <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(total = sum(despesa_total))
                 population <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
                 episodes <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               },
               "Muito baixo (<1)" = {
                 data_plot <- base_dados %>% filter(IPA>0 & IPA<1) %>% group_by(ano) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                       surveillance_control = sum(gasto_total_vigil_control),
                                                                                                       human_resources = sum(total_rh)) %>% arrange(ano)
                 
                 total_plot <- base_dados %>% filter(IPA > 0 & IPA<1) %>% group_by(ano) %>% summarise(total = sum(despesa_total))
                 population <- base_dados %>% filter(IPA > 0 & IPA<1) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
                 episodes <- base_dados %>% filter(IPA > 0 & IPA<1) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)               
               },
               "Baixo (>=1 e <50)" = {
                 data_plot <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                            surveillance_control = sum(gasto_total_vigil_control),
                                                                                            human_resources = sum(total_rh)) %>% arrange(ano)
                 
                 total_plot <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(total = sum(despesa_total))
                 population <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
                 episodes <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               },
               "Alto (>=50)" = {
                 data_plot <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                           surveillance_control = sum(gasto_total_vigil_control),
                                                                                           human_resources = sum(total_rh)) %>% arrange(ano)
                 
                 total_plot <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(total = sum(despesa_total))
                 population <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
                 episodes <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)               
               }
               
        )
        stacked_bar_indicators(data_plot, total_plot, population, episodes, translate("total_expenditures_names"), "R$", 2, "", translate("total_name"),  translate("ano"), translate("total_expenditures_yaxis"), indicator_applied())
      } else{
        switch(ipa_group_total_choices(),
               "Zero (0)" = {
                 values <- t(base_dados %>% filter(ano == input$year_input & IPA==0) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                            surveillance_control = sum(gasto_total_vigil_control),
                                                                                            human_resources = sum(total_rh)))
                 
                 population <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(pop),na.rm = TRUE)
                 episodes <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(notificacoes),na.rm = TRUE)
               },
               "Muito baixo (<1)" = {
                 values <- t(base_dados %>% filter(ano == input$year_input & IPA > 0 & IPA<1) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                      surveillance_control = sum(gasto_total_vigil_control),
                                                                                                      human_resources = sum(total_rh)))
                 
                 population <- sum(base_dados %>% filter(ano == input$year_input & IPA > 0 & IPA<1) %>% pull(pop),na.rm = TRUE)
                 episodes <- sum(base_dados %>% filter(ano == input$year_input & IPA > 0 & IPA<1) %>% pull(notificacoes),na.rm = TRUE)              
               },
               "Baixo (>=1 e <50)" = {
                 values <- t(base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                            surveillance_control = sum(gasto_total_vigil_control),
                                                                                                            human_resources = sum(total_rh)))
                 
                 population <- sum(base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% pull(pop),na.rm = TRUE)
                 episodes <- sum(base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% pull(notificacoes),na.rm = TRUE)              
               },
               "Alto (>=50)" = {
                 values <- t(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% summarise(diagnostic_treatment = sum(gasto_diagtrat_total),
                                                                                                      surveillance_control = sum(gasto_total_vigil_control),
                                                                                                      human_resources = sum(total_rh)))
                 
                 population <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(pop),na.rm = TRUE)
                 episodes <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(notificacoes),na.rm = TRUE)
               }
               
        )
        data_plot <- data.frame(cbind(translate("total_expenditures_names"), values))
        colnames(data_plot) <- c("categories", "values")
        colors <- c('rgb(0,0,139)','rgb(102,205,0)', "rgb(85,105,47)")
        
        pie_chart_indicators(data_plot, population, episodes, "R$", 2, "", colors, indicator_applied())
      }

    } else{
      zero_api <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(total_zero = sum(despesa_total)) 
      very_low_api <- base_dados %>% filter(IPA > 0 & IPA<1) %>% group_by(ano) %>% summarise(total_very_low = sum(despesa_total)) 
      low_api <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(total_low = sum(despesa_total)) 
      high_api <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(total_high = sum(despesa_total))
      data_plot <- merge(zero_api, very_low_api, by = "ano") %>% merge(low_api, by = "ano") %>% merge(high_api, by = "ano")
      switch(indicator_applied(),
             "Valores absolutos" = {
               hover_post <- ""
             },
             "Per capita" = {
               population_zero <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               population_very_low <- base_dados %>% filter(IPA > 0 & IPA<1) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               population_low <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               population_high <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(population = sum(pop)) %>% arrange(ano)
               data_plot$total_zero <- data_plot$total_zero/population_zero$population
               data_plot$total_very_low <- data_plot$total_very_low/population_very_low$population
               data_plot$total_low <- data_plot$total_low/population_low$population
               data_plot$total_high <- data_plot$total_high/population_high$population
               
               hover_post <- "per capita"
             },
             "Por notificação" = {
               episodes_zero <- base_dados %>% filter(IPA==0) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               episodes_very_low <- base_dados %>% filter(IPA > 0 & IPA<1) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               episodes_low <- base_dados %>% filter(IPA>=1 & IPA<50) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               episodes_high <- base_dados %>% filter(IPA>=50) %>% group_by(ano) %>% summarise(episodes = sum(notificacoes)) %>% arrange(ano)
               data_plot$total_zero <- data_plot$total_zero/episodes_zero$episodes
               data_plot$total_very_low <- data_plot$total_very_low/episodes_very_low$episodes
               data_plot$total_low <- data_plot$total_low/episodes_low$episodes
               data_plot$total_high <- data_plot$total_high/episodes_high$episodes
               
               hover_post <- translate("episode_card_graph")
             }
             
             
             )
      line_graph(data_plot, translate("ipa_groups"), translate("ano"), translate("total_expenditures_yaxis"), "R$",2,hover_post)
    }
  })
  
#Download-----------------------------------------------------------------------

  output$download_button <- renderUI({
    div(
      style = "position:relative; left:calc(25%);",
      downloadButton(
        outputId = "download_data",
        label = "Download",
        style = "color: #fff; background-color: #27ae60; border-color: #fff;"
      ) 
    )
  })

output$download_data <- downloadHandler(
  filename = function(){
    switch(input$sidebar_menu,
           "epidemiological_tab" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("epidemiological_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("epidemiological_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )
           },
           "diagnostic_treatment_tab_hidden" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("diagnostic_treatment_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("diagnostic_treatment_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )             
           },
           "diagnostic_tab" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("diagnostic_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("diagnostic_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )             
           },
           "treatment_tab" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("treatment_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("treatment_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )             
           },
           "surveillance_control_tab_hidden" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("surveillance_control_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("surveillance_control_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )
           },
           "surveillance_tab" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("surveillance_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("surveillance_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )             
           },
           "control_tab" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("control_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("control_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )             
           },
           "human_resources_tab" = {
             ifelse(input$aggregation_input > 0,
                    paste(translate("human_resources_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                    paste(translate("human_resources_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
             )
           },
           "total_expenditures_tab" = {
             switch(input$total_expenditures_box,
                    "uf_mun_total" = {
                      ifelse(input$aggregation_input > 0,
                             paste(translate("total_expenditures_tab_file"), input$uf_input,"_",input$year_input,"-",Sys.Date(), '.xlsx', sep=''),
                             paste(translate("total_expenditures_tab_file"), input$uf_input,"_",input$city_input,"_", input$year_input,"-",Sys.Date(), '.xlsx', sep='')
                      )                      
                    },
                    "ipa_group_total" = {
                      if(input$ipa_total_comparison == 0){
                        paste(translate("total_expenditures_IPA_group_tab_file"),"_",input$year_input,"-", Sys.Date(), '.xlsx', sep='')
                      } else{
                        switch(ipa_group_total_choices(),
                               "Zero (0)" = {
                                 paste(translate("total_expenditures_zero_IPA_tab_file"),"_",input$year_input,"-", Sys.Date(), '.xlsx', sep='')
                               },
                               "Muito baixo (<1)" = {
                                 paste(translate("total_expenditures_very_low_IPA_tab_file"),"_",input$year_input,"-", Sys.Date(), '.xlsx', sep='')                                 
                               },
                               "Baixo (>=1 e <50)" = {
                                 paste(translate("total_expenditures_low_IPA_tab_file"),"_",input$year_input,"-", Sys.Date(), '.xlsx', sep='')                                 
                               },
                               "Alto (>=50)" = {
                                 paste(translate("total_expenditures_high_IPA_tab_file"),"_",input$year_input,"-", Sys.Date(), '.xlsx', sep='')                                 
                               }
                               
                               
                               )
                      }
                    },
                    "amazonic_region_total" = {
                      paste(translate("total_expenditures_amazonic_region"),"_",input$year_input,"-", Sys.Date(), '.xlsx', sep='')                      
                    }
                    
                    )
           }
           
           )
  },
  
  content = function(file){
    switch(input$sidebar_menu,
           "epidemiological_tab" = {
             if(input$aggregation_input > 0){
               populacao <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (pop), na.rm = TRUE)
               notificacoes <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (notificacoes), na.rm = TRUE)
               descartados <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_descartados), na.rm = TRUE)
               confirmados <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (notificacoes), na.rm = TRUE)
               zeroACincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(-Inf,5]_F'), na.rm = TRUE)
               zeroACincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(-Inf,5]_M'), na.rm = TRUE)
               cincoADezF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(5,10]_F'), na.rm = TRUE)
               cincoADezM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(5,10]_M'), na.rm = TRUE)
               dezAQuinzeF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(10,15]_F'), na.rm = TRUE)
               dezAQuinzeM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(10,15]_M'), na.rm = TRUE)
               quinzeAVinteF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(15,20]_F'), na.rm = TRUE)
               quinzeAVinteM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(15,20]_M'), na.rm = TRUE)
               vinteAVinteCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(20,25]_F'), na.rm = TRUE)
               vinteAVinteCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(20,25]_M'), na.rm = TRUE)
               vinteCincoATrintaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(25,30]_F'), na.rm = TRUE)
               vinteCincoATrintaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(25,30]_M'), na.rm = TRUE)
               trintaATrintaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(30,35]_F'), na.rm = TRUE)
               trintaATrintaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(30,35]_M'), na.rm = TRUE)
               trintaCincoAQuarentaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(35,40]_F'), na.rm = TRUE)
               trintaCincoAQuarentaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(35,40]_M'), na.rm = TRUE)
               quarentaAQuarentaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(40,45]_F'), na.rm = TRUE)
               quarentaAQuarentaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(40,45]_M'), na.rm = TRUE)
               quarentaCincoACinquentaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(45,50]_F'), na.rm = TRUE)
               quarentaCincoACinquentaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(45,50]_M'), na.rm = TRUE)
               cinquentaACinquentaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(50,55]_F'), na.rm = TRUE)
               cinquentaACinquentaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(50,55]_M'), na.rm = TRUE)
               cinquentaCincoASessentaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(55,60]_F'), na.rm = TRUE)
               cinquentaCincoASessentaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(55,60]_M'), na.rm = TRUE)
               sessentaASessentaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(60,65]_F'), na.rm = TRUE)
               sessentaASessentaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(60,65]_M'), na.rm = TRUE)
               sessentaCincoASetentaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(65,70]_F'), na.rm = TRUE)
               sessentaCincoASetentaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(65,70]_M'), na.rm = TRUE)
               setentaASetentaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(70,75]_F'), na.rm = TRUE)
               setentaASetentaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(70,75]_M'), na.rm = TRUE)
               setentaCincoAOitentaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(75,80]_F'), na.rm = TRUE)
               setentaCincoAOitentaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(75,80]_M'), na.rm = TRUE)
               oitentaAOitentaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(80,85]_F'), na.rm = TRUE)
               oitentaAOitentaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(80,85]_M'), na.rm = TRUE)
               oitentaCincoANoventaF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(85,90]_F'), na.rm = TRUE)
               oitentaCincoANoventaM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(85,90]_M'), na.rm = TRUE)
               noventaANoventaCincoF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(90,95]_F'), na.rm = TRUE)
               noventaANoventaCincoM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(90,95]_M'), na.rm = TRUE)
               noventaCincoMaisF <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(95, Inf]_F'), na.rm = TRUE)
               noventaCincoMaisM <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull ('(95, Inf]_M'), na.rm = TRUE)
               leves <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_leves), na.rm = TRUE)
               graves <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_severos), na.rm = TRUE)
               lvc <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_lvc), na.rm = TRUE)
               internacoes <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (hospitalizacoes_n), na.rm = TRUE)
               
               vivax_uf <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_vivax), na.rm = TRUE)
               falciparum_uf <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_falciparum), na.rm = TRUE)
               outros_uf <- sum(base_dados %>% filter (estado == input$uf_input & ano == input$year_input) %>% pull (casos_outros), na.rm = TRUE)
               ipa_uf <- base_ipa_uf %>% filter(ano == input$year_input) %>% pull(input$uf_input)
               xlsx_write = data.frame(cbind(input$year_input, input$uf_input, populacao, notificacoes, descartados, confirmados, zeroACincoF, zeroACincoM, cincoADezF, cincoADezM, dezAQuinzeF, dezAQuinzeM, quinzeAVinteF, quinzeAVinteM, vinteAVinteCincoF, vinteAVinteCincoM, vinteCincoATrintaF, vinteCincoATrintaM, trintaATrintaCincoF, trintaATrintaCincoM, trintaCincoAQuarentaF, trintaCincoAQuarentaM, quarentaAQuarentaCincoF, quarentaAQuarentaCincoM, quarentaCincoACinquentaF, quarentaCincoACinquentaM, cinquentaACinquentaCincoF, cinquentaACinquentaCincoM, cinquentaCincoASessentaF, cinquentaCincoASessentaM, sessentaASessentaCincoF, sessentaASessentaCincoM, sessentaCincoASetentaF, sessentaCincoASetentaM, setentaASetentaCincoF, setentaASetentaCincoM, setentaCincoAOitentaF, setentaCincoAOitentaM, oitentaAOitentaCincoF, oitentaAOitentaCincoM, oitentaCincoANoventaF, oitentaCincoANoventaM, noventaANoventaCincoF, noventaANoventaCincoM, noventaCincoMaisF, noventaCincoMaisM, leves, graves,lvc,internacoes, vivax_uf, falciparum_uf, outros_uf, ipa_uf))
               colnames(xlsx_write) <- translate("epidemiological_col_names_uf")
             } else{
               
               populacao <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(pop)
               notificacoes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
               descartados <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_descartados)
               confirmados <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(notificacoes)
               zeroACincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(-Inf,5]_F')
               zeroACincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(-Inf,5]_M')
               cincoADezF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(5,10]_F')
               cincoADezM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(5,10]_M')
               dezAQuinzeF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(10,15]_F')
               dezAQuinzeM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(10,15]_M')
               quinzeAVinteF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(15,20]_F')
               quinzeAVinteM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(15,20]_M')
               vinteAVinteCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(20,25]_F')
               vinteAVinteCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(20,25]_M')
               vinteCincoATrintaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(25,30]_F')
               vinteCincoATrintaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(25,30]_M')
               trintaATrintaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(30,35]_F')
               trintaATrintaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(30,35]_M')
               trintaCincoAQuarentaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(35,40]_F')
               trintaCincoAQuarentaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(35,40]_M')
               quarentaAQuarentaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(40,45]_F')
               quarentaAQuarentaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(40,45]_M')
               quarentaCincoACinquentaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(45,50]_F')
               quarentaCincoACinquentaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(45,50]_M')
               cinquentaACinquentaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(50,55]_F')
               cinquentaACinquentaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(50,55]_M')
               cinquentaCincoASessentaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(55,60]_F')
               cinquentaCincoASessentaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(55,60]_M')
               sessentaASessentaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(60,65]_F')
               sessentaASessentaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(60,65]_M')
               sessentaCincoASetentaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(65,70]_F')
               sessentaCincoASetentaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(65,70]_M')
               setentaASetentaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(70,75]_F')
               setentaASetentaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(70,75]_M')
               setentaCincoAOitentaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(75,80]_F')
               setentaCincoAOitentaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(75,80]_M')
               oitentaAOitentaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(80,85]_F')
               oitentaAOitentaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(80,85]_M')
               oitentaCincoANoventaF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(85,90]_F')
               oitentaCincoANoventaM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(85,90]_M')
               noventaANoventaCincoF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(90,95]_F')
               noventaANoventaCincoM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(90,95]_M')
               noventaCincoMaisF <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(95, Inf]_F')
               noventaCincoMaisM <- base_dados %>% filter (estado == input$uf_input & ano == input$year_input & base_dados$nome_municipio==input$city_input) %>% pull ('(95, Inf]_M')
               leves <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_leves)
               graves <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_severos)
               lvc <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(casos_lvc)
               internacoes <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(hospitalizacoes_n)
               
               vivax_mun <- base_dados %>% filter (estado == input$uf_input & nome_municipio == input$city_input & ano == input$year_input) %>% pull (casos_vivax)
               falciparum_mun <- base_dados %>% filter (estado == input$uf_input & nome_municipio == input$city_input & ano == input$year_input) %>% pull (casos_falciparum)
               outros_mun <- base_dados %>% filter (estado == input$uf_input & nome_municipio == input$city_input & ano == input$year_input) %>% pull (casos_outros)
               ipa_uf <- base_ipa_uf %>% filter(ano == input$year_input) %>% pull(input$uf_input)
               ipa_mun <- base_dados %>% filter(estado == input$uf_input & nome_municipio == input$city_input & ano == input$year_input) %>% pull(IPA)
               xlsx_write = data.frame(cbind(input$year_input, input$uf_input, input$city_input, populacao, notificacoes, descartados, confirmados,leves, zeroACincoF, zeroACincoM, cincoADezF, cincoADezM, dezAQuinzeF, dezAQuinzeM, quinzeAVinteF, quinzeAVinteM, vinteAVinteCincoF, vinteAVinteCincoM, vinteCincoATrintaF, vinteCincoATrintaM, trintaATrintaCincoF, trintaATrintaCincoM, trintaCincoAQuarentaF, trintaCincoAQuarentaM, quarentaAQuarentaCincoF, quarentaAQuarentaCincoM, quarentaCincoACinquentaF, quarentaCincoACinquentaM, cinquentaACinquentaCincoF, cinquentaACinquentaCincoM, cinquentaCincoASessentaF, cinquentaCincoASessentaM, sessentaASessentaCincoF, sessentaASessentaCincoM, sessentaCincoASetentaF, sessentaCincoASetentaM, setentaASetentaCincoF, setentaASetentaCincoM, setentaCincoAOitentaF, setentaCincoAOitentaM, oitentaAOitentaCincoF, oitentaAOitentaCincoM, oitentaCincoANoventaF, oitentaCincoANoventaM, noventaANoventaCincoF, noventaANoventaCincoM, noventaCincoMaisF, noventaCincoMaisM, graves,lvc,internacoes, vivax_mun, falciparum_mun, outros_mun, ipa_uf, ipa_mun))
               colnames(xlsx_write) <- translate("epidemiological_col_names_mun")
             }

           },
           "diagnostic_treatment_tab_hidden" = {
             if(input$aggregation_input > 0){
               rapid_test <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(exame_teste_rapido),na.rm = TRUE)
               rapid_test_expenditure <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(gasto_teste_rapido),na.rm = TRUE)
               blood_smear <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(exame_gota_espessa),na.rm = TRUE)
               blood_smear_expenditure <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(gasto_gota_espessa),na.rm = TRUE)
               pharmaceuticals_expenditure <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(medicamento_total),na.rm = TRUE)
               hospitalizations_expenditure <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(hospitalizacoes_gasto),na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, rapid_test, rapid_test_expenditure, blood_smear, blood_smear_expenditure, pharmaceuticals_expenditure, hospitalizations_expenditure))
               colnames(xlsx_write) <- translate("diagnostic_treatment_col_names_uf")
             } else{
               rapid_test <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_teste_rapido)
               rapid_test_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_teste_rapido)
               blood_smear <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_gota_espessa)
               blood_smear_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_gota_espessa)
               pharmaceuticals_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(medicamento_total)
               hospitalizations_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(hospitalizacoes_gasto)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input, rapid_test, rapid_test_expenditure, blood_smear, blood_smear_expenditure, pharmaceuticals_expenditure, hospitalizations_expenditure))
               colnames(xlsx_write) <- translate("diagnostic_treatment_col_names_mun")
             }
           },
           "diagnostic_tab" = {
             if(input$aggregation_input > 0){
               rapid_test <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(exame_teste_rapido),na.rm = TRUE)
               rapid_test_expenditure <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(gasto_teste_rapido),na.rm = TRUE)
               blood_smear <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(exame_gota_espessa),na.rm = TRUE)
               blood_smear_expenditure <- sum(base_dados %>% filter(ano == input$year_input & uf == input$uf_input) %>% pull(gasto_gota_espessa),na.rm = TRUE)
               rapid_test_positive <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_rapido_confirmado),na.rm = TRUE)
               rapid_test_positive_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(gasto_rapido_confirmado),na.rm = TRUE)
               blood_smear_positive <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_gota_confirmado),na.rm = TRUE)
               blood_smear_positive_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(gasto_gota_confirmado),na.rm = TRUE)
               rapid_test_vivax <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_rapido_vivax),na.rm = TRUE)
               rapid_test_vivax_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(custo_rapido_vivax),na.rm = TRUE)
               blood_smear_vivax <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_gota_vivax),na.rm = TRUE)
               blood_smear_vivax_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(custo_gota_vivax),na.rm = TRUE)
               rapid_test_falciparum <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_rapido_falciparum),na.rm = TRUE)
               rapid_test_falciparum_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(custo_rapido_falciparum),na.rm = TRUE)
               blood_smear_falciparum <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_gota_falciparum),na.rm = TRUE)
               blood_smear_falciparum_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(custo_gota_falciparum),na.rm = TRUE)
               rapid_test_others <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_rapido_outros),na.rm = TRUE)
               rapid_test_others_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(custo_rapido_outros),na.rm = TRUE)
               blood_smear_others <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(exame_gota_outros),na.rm = TRUE)
               blood_smear_others_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(custo_gota_outros),na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, rapid_test, rapid_test_expenditure, blood_smear, blood_smear_expenditure, rapid_test_positive, rapid_test_positive_expenditure, blood_smear_positive, blood_smear_positive_expenditure, rapid_test_vivax, rapid_test_vivax_expenditure, blood_smear_vivax, blood_smear_vivax_expenditure, rapid_test_falciparum, rapid_test_falciparum_expenditure, blood_smear_falciparum, blood_smear_falciparum_expenditure, rapid_test_others, rapid_test_others_expenditure, blood_smear_others, blood_smear_others_expenditure))
               colnames(xlsx_write) <- translate("diagnostic_col_names_uf")
             } else{
               rapid_test <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_teste_rapido)
               rapid_test_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_teste_rapido)
               blood_smear <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_gota_espessa)
               blood_smear_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_gota_espessa)
               rapid_test_positive <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_rapido_confirmado)
               rapid_test_positive_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_rapido_confirmado)
               blood_smear_positive <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_gota_confirmado)
               blood_smear_positive_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_gota_confirmado)
               rapid_test_vivax <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_rapido_vivax)
               rapid_test_vivax_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(custo_rapido_vivax)
               blood_smear_vivax <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_gota_vivax)
               blood_smear_vivax_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(custo_gota_vivax)
               rapid_test_falciparum <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_rapido_falciparum)
               rapid_test_falciparum_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(custo_rapido_falciparum)
               blood_smear_falciparum <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_gota_falciparum)
               blood_smear_falciparum_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(custo_gota_falciparum)
               rapid_test_others <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_rapido_outros)
               rapid_test_others_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(custo_rapido_outros)
               blood_smear_others <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(exame_gota_outros)
               blood_smear_others_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(custo_gota_outros)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input,rapid_test, rapid_test_expenditure, blood_smear, blood_smear_expenditure, rapid_test_positive, rapid_test_positive_expenditure, blood_smear_positive, blood_smear_positive_expenditure, rapid_test_vivax, rapid_test_vivax_expenditure, blood_smear_vivax, blood_smear_vivax_expenditure, rapid_test_falciparum, rapid_test_falciparum_expenditure, blood_smear_falciparum, blood_smear_falciparum_expenditure, rapid_test_others, rapid_test_others_expenditure, blood_smear_others, blood_smear_others_expenditure))
               colnames(xlsx_write) <- translate("diagnostic_col_names_mun")
             }
           },
           "treatment_tab" = {
             if(input$aggregation_input > 0){
               pharmaceuticals_vivax <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(medicamento_esq_1), na.rm = TRUE)
               pharmaceuticals_falciparum <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(medicamento_esq_2), na.rm =TRUE)
               pharmaceuticals_others <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(medicamento_esq_3_4), na.rm = TRUE)
               pharmaceuticals_severe <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(medicamento_esq_5), na.rm = TRUE)
               hospitalizations_number <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(hospitalizacoes_n), na.rm =TRUE)
               hospitalizations_length <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(hospitalizacoes_dias), na.rm = TRUE)/hospitalizations_number
               hospitalizations_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(hospitalizacoes_gasto), na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, pharmaceuticals_vivax, pharmaceuticals_falciparum, pharmaceuticals_others, pharmaceuticals_severe, hospitalizations_number, hospitalizations_length, hospitalizations_expenditure))
               colnames(xlsx_write) <- translate("treatment_col_names_uf")
             } else{
               pharmaceuticals_vivax <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(medicamento_esq_1)
               pharmaceuticals_falciparum <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(medicamento_esq_2)
               pharmaceuticals_others <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(medicamento_esq_3_4)
               pharmaceuticals_severe <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(medicamento_esq_5)
               hospitalizations_number <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(hospitalizacoes_n)
               hospitalizations_length <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(hospitalizacoes_dias)
               hospitalizations_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(hospitalizacoes_gasto)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input, pharmaceuticals_vivax, pharmaceuticals_falciparum, pharmaceuticals_others, pharmaceuticals_severe, hospitalizations_number, hospitalizations_length, hospitalizations_expenditure))
               colnames(xlsx_write) <- translate("treatment_col_names_mun")
             }
           },
           "surveillance_control_tab_hidden" = {
             if(input$aggregation_input > 0){
               surveillance_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(vigilancia), na.rm = TRUE)
               screening_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(screening), na.rm = TRUE)
               bed_nest_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(mosquiteiro), na.rm = TRUE)
               insecticide_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(inseticida), na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, surveillance_expenditure, screening_expenditure, bed_nest_expenditure,insecticide_expenditure))
               colnames(xlsx_write) <- translate("surveillance_control_col_names_uf")
             } else{
               surveillance_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(vigilancia)
               screening_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(screening)
               bed_nest_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(mosquiteiro)
               insecticide_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(inseticida)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input,surveillance_expenditure, screening_expenditure, bed_nest_expenditure,insecticide_expenditure))
               colnames(xlsx_write) <- translate("surveillance_control_col_names_mun")
             }
           },
           "surveillance_tab" = {
             if(input$aggregation_input > 0){
               surveillance_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(vigilancia), na.rm = TRUE)
               blood_bags <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(bolsas),na.rm = TRUE)
               screening_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(screening), na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, surveillance_expenditure, blood_bags, screening_expenditure))
               colnames(xlsx_write) <- translate("surveillance_col_names_uf")
             } else{
               surveillance_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(vigilancia)
               blood_bags <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(bolsas)
               screening_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(screening)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input, surveillance_expenditure, blood_bags, screening_expenditure))
               colnames(xlsx_write) <- translate("surveillance_col_names_mun")
             }
           },
           "control_tab" = {
             if(input$aggregation_input > 0){
               bed_nest_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(mosquiteiro), na.rm = TRUE)
               insecticide_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input  ) %>% pull(inseticida), na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, bed_nest_expenditure, insecticide_expenditure))
               colnames(xlsx_write) <- translate("control_col_names_uf")
             } else{
               bed_nest_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(mosquiteiro)
               insecticide_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(inseticida)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input,bed_nest_expenditure, insecticide_expenditure))
               colnames(xlsx_write) <- translate("control_col_names_mun")
             }
           },
           "human_resources_tab" = {
             if(input$aggregation_input > 0){
               number_cha <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(acs), na.rm = TRUE)
               expenditure_cha <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(salario_acs), na.rm = TRUE)
               number_microscopists <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(microscopista), na.rm = TRUE)
               expenditure_microscopists <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(salario_microscopista), na.rm = TRUE)
               number_municipalities_incentive <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% summarise(number = sum(incentivo != 0))
               incentive <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(incentivo), na.rm = TRUE)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, number_cha, expenditure_cha, number_microscopists, expenditure_microscopists, number_municipalities_incentive$number, incentive))
               colnames(xlsx_write) <- translate("human_resources_col_names_uf")
             } else{
               number_cha <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(acs)
               expenditure_cha <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(salario_acs)
               number_microscopists <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(microscopista)
               expenditure_microscopists <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(salario_microscopista)
               incentive <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(incentivo)
               xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input, number_cha, expenditure_cha, number_microscopists, expenditure_microscopists, incentive))
               colnames(xlsx_write) <- translate("human_resources_col_names_mun")
             }
           },
           "total_expenditures_tab" = {
             switch(input$total_expenditures_box,
                    "uf_mun_total" = {
                      if(input$aggregation_input > 0){
                        diagnostic_treatment <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(gasto_diagtrat_total), na.rm = TRUE)
                        surveillance_control <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(gasto_total_vigil_control), na.rm = TRUE)
                        human_resources <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(total_rh), na.rm = TRUE)
                        total_expenditure <- sum(base_dados %>% filter(ano == input$year_input & estado == input$uf_input) %>% pull(despesa_total), na.rm = TRUE)
                        xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                        colnames(xlsx_write) <- translate("total_expenditures_uf_mun_col_names_uf")
                      } else{
                        diagnostic_treatment <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_diagtrat_total)
                        surveillance_control <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(gasto_total_vigil_control)
                        human_resources <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(total_rh)
                        total_expenditure <- base_dados %>% filter(ano == input$year_input & estado == input$uf_input & nome_municipio == input$city_input) %>% pull(despesa_total)
                        xlsx_write <- data.frame(cbind(input$year_input, input$uf_input, input$city_input,diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                        colnames(xlsx_write) <- translate("total_expenditures_uf_mun_col_names_mun")
                      }
                    },
                    "ipa_group_total" = {
                      if(input$ipa_total_comparison == 0){
                        switch(ipa_group_total_choices(),
                               "Zero (0)" = {
                                 diagnostic_treatment <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(gasto_diagtrat_total), na.rm = TRUE)
                                 surveillance_control <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(gasto_total_vigil_control), na.rm = TRUE)
                                 human_resources <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(total_rh), na.rm = TRUE)
                                 total_expenditure <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(despesa_total), na.rm = TRUE)
                                 xlsx_write <- data.frame(cbind(input$year_input, diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                                 colnames(xlsx_write) <- translate("total_expenditures_ipa_group_total_col_names")
                               },
                               "Muito baixo (<1)" = {
                                 diagnostic_treatment <- sum(base_dados %>% filter(ano == input$year_input & IPA>0 & IPA <1) %>% pull(gasto_diagtrat_total), na.rm = TRUE)
                                 surveillance_control <- sum(base_dados %>% filter(ano == input$year_input & IPA>0 & IPA <1) %>% pull(gasto_total_vigil_control), na.rm = TRUE)
                                 human_resources <- sum(base_dados %>% filter(ano == input$year_input & IPA>0 & IPA <1) %>% pull(total_rh), na.rm = TRUE)
                                 total_expenditure <- sum(base_dados %>% filter(ano == input$year_input & IPA>0 & IPA <1) %>% pull(despesa_total), na.rm = TRUE)
                                 xlsx_write <- data.frame(cbind(input$year_input, diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                                 colnames(xlsx_write) <- translate("total_expenditures_ipa_group_total_col_names")
                               },
                               "Baixo (>=1 e <50)" = {
                                 diagnostic_treatment <- sum(base_dados %>% filter(ano == input$year_input & IPA>1 & IPA <50) %>% pull(gasto_diagtrat_total), na.rm = TRUE)
                                 surveillance_control <- sum(base_dados %>% filter(ano == input$year_input & IPA>1 & IPA <50) %>% pull(gasto_total_vigil_control), na.rm = TRUE)
                                 human_resources <- sum(base_dados %>% filter(ano == input$year_input & IPA>1 & IPA <50) %>% pull(total_rh), na.rm = TRUE)
                                 total_expenditure <- sum(base_dados %>% filter(ano == input$year_input & IPA>1 & IPA <50) %>% pull(despesa_total), na.rm = TRUE)
                                 xlsx_write <- data.frame(cbind(input$year_input, diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                                 colnames(xlsx_write) <- translate("total_expenditures_ipa_group_total_col_names") 
                               },
                               "Alto (>=50)" = {
                                 diagnostic_treatment <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(gasto_diagtrat_total), na.rm = TRUE)
                                 surveillance_control <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(gasto_total_vigil_control), na.rm = TRUE)
                                 human_resources <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(total_rh), na.rm = TRUE)
                                 total_expenditure <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(despesa_total), na.rm = TRUE)
                                 xlsx_write <- data.frame(cbind(input$year_input, diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                                 colnames(xlsx_write) <- translate("total_expenditures_ipa_group_total_col_names") 
                               }
                               
                               
                        )
                      } else{
                        zero_ipa_total <- sum(base_dados %>% filter(ano == input$year_input & IPA==0) %>% pull(despesa_total), na.rm = TRUE)
                        very_low_ipa_total <- sum(base_dados %>% filter(ano == input$year_input & IPA>0 & IPA <1) %>% pull(despesa_total), na.rm = TRUE)
                        low_ipa_total <- sum(base_dados %>% filter(ano == input$year_input & IPA>=1 & IPA<50) %>% pull(despesa_total), na.rm = TRUE)
                        high_ipa_total <- sum(base_dados %>% filter(ano == input$year_input & IPA>=50) %>% pull(despesa_total), na.rm = TRUE)
                        xlsx_write <- data.frame(cbind(input$year_input, zero_ipa_total, very_low_ipa_total, low_ipa_total, high_ipa_total))
                        colnames(xlsx_write) <- translate("total_expenditures_ipa_group_total_comparison_col_names")
                      }
                    },
                    "amazonic_region_total" = {
                      diagnostic_treatment <- sum(base_dados %>% filter(ano == input$year_input) %>% pull(gasto_diagtrat_total), na.rm = TRUE)
                      surveillance_control <- sum(base_dados %>% filter(ano == input$year_input) %>% pull(gasto_total_vigil_control), na.rm = TRUE)
                      human_resources <- sum(base_dados %>% filter(ano == input$year_input) %>% pull(total_rh), na.rm = TRUE)
                      total_expenditure <- sum(base_dados %>% filter(ano == input$year_input) %>% pull(despesa_total), na.rm = TRUE)
                      xlsx_write <- data.frame(cbind(input$year_input, diagnostic_treatment, surveillance_control, human_resources, total_expenditure))
                      colnames(xlsx_write) <- translate("total_expenditures_ipa_group_total_col_names")
                    }
                    
             )
           }
           
    )
    write_xlsx(xlsx_write, file)
  }
)
  
}


#Execução do app----------------------------------------------------------------
shinyApp(ui = ui, server = server)