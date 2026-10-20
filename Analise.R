# ==============================================================================
# SCRIPT DE VALIDAÇÃO DE DADOS DA DASHBOARD - AWS
# Bibliotecas focadas: dplyr (manipulação) e ggplot2 (visualização)
# ==============================================================================

# 1. Carregando as bibliotecas separadamente
library(dplyr)
library(ggplot2)
library(readr)     # Para ler o CSV
library(lubridate) # Para tratar as datas e horas

# 2. Lendo os dados brutos da AWS
csv <- "3b12f1df-5232-4df4-8d48-64a938c2-2026-10-19.csv"
# read_delim com delim = ";" já que seu arquivo usa ponto e vírgula
dados_aws <- read_delim(csv, delim = ";", show_col_types = FALSE)

# 3. Preparando as colunas de tempo com dplyr (mutate)
dados_aws <- dados_aws %>%
  mutate(
    TimeStamp = ymd_hms(TimeStamp),
    Data = as_date(TimeStamp),
    Hora = format(TimeStamp, "%H:%M:%S")
  )

# ==============================================================================
# ETAPA A: COMPROVAÇÃO DA DASHBOARD (Usando dplyr)
# ==============================================================================
cat("\n--- ETAPA A: COMPROVAÇÃO DA DASH (Recorte de 5 minutos) ---\n")

comprovacao_dash <- dados_aws %>%
  filter(Hora >= "20:30:00" & Hora <= "20:35:00") %>% 
  summarise(
    CPU_Uso_Atual = last(UsoCPU_Geral),
    CPU_Media_5min = mean(UsoCPU_Geral, na.rm = TRUE),
    CPU_Pico_5min = max(UsoCPU_Geral, na.rm = TRUE),
    RAM_Media_5min = mean(UsoRAM, na.rm = TRUE),
    Disco_Ocupado = last(UsoDisco)
  )

print(comprovacao_dash)

# ==============================================================================
# ETAPA B: ANÁLISE DE PICOS E LIMITES (Usando dplyr)
# ==============================================================================
cat("\n--- ETAPA B: PICOS E GARGALOS NA OPERAÇÃO ---\n")

picos_operacao <- dados_aws %>%
  summarise(
    Max_CPU = max(UsoCPU_Geral, na.rm = TRUE),
    Max_RAM = max(UsoRAM, na.rm = TRUE),
    Max_Disco = max(UsoDisco, na.rm = TRUE),
    Vezes_CPU_Critica = sum(UsoCPU_Geral >= 90, na.rm = TRUE)
  )

print(picos_operacao)

# ==============================================================================
# ETAPA C: DIAS NORMAIS VS FERIADOS (Usando dplyr)
# ==============================================================================
cat("\n--- ETAPA C: IMPACTO SAZONAL ---\n")

# Definindo alguns feriados como exemplo
datas_feriados <- as_date(c("2026-09-07", "2026-10-12", "2026-11-02", "2026-12-25"))

comparacao_sazonal <- dados_aws %>%
  mutate(
    Tipo_Dia = case_when(
      Data %in% datas_feriados ~ "Feriado",
      wday(Data) %in% c(1, 7) ~ "Fim de Semana",
      TRUE ~ "Dia Normal"
    )
  ) %>%
  group_by(Tipo_Dia) %>%
  summarise(
    Media_CPU = mean(UsoCPU_Geral, na.rm = TRUE),
    Pico_CPU = max(UsoCPU_Geral, na.rm = TRUE),
    Total_Leituras = n()
  ) %>%
  arrange(desc(Pico_CPU))

print(comparacao_sazonal)

# ==============================================================================
# ETAPA D: VISUALIZAÇÃO GRÁFICA DA CPU (Usando ggplot2)
# ==============================================================================
grafico_validacao <- dados_aws %>%
  ggplot(aes(x = TimeStamp, y = UsoCPU_Geral)) +
  geom_line(color = "#2b8cbe", size = 1) +
  geom_hline(yintercept = 90, color = "#de2d26", linetype = "dashed", size = 1) +
  labs(
    title = "Comprovação da Dashboard: Uso de CPU",
    subtitle = "Linha tracejada vermelha representa o limite crítico (90%)",
    x = "Tempo",
    y = "Uso de CPU (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 10)
  )

print(grafico_validacao)

