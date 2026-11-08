library(corrplot)

df_componente <- ComponentesAtt

df_componente$TimeStamp <- NULL
df_componente$IdAeroporto <- NULL
df_componente$Temperatura_CPU <- NULL
df_componente$Swap_Out <- NULL
df_componente$Swap_In <- NULL
df_componente$Rede_Drop_Out <- NULL
df_componente$Rede_Drop_In <- NULL
df_componente$Rede_Err_Out <- NULL
df_componente$Rede_Err_In <- NULL
df_componente$Disco_Total <- NULL
df_componente$RAM_Total <- NULL
df_componente$CPU_Nucleos_Fisicos <- NULL
df_componente$CPU_Nucleos_Logicos <- NULL
df_componente$Swap_Total <- NULL
df_componente$CPU_Freq_Atual <- NULL
df_componente$RAM_Disponivel <- NULL
df_componente$RAM_Usada <- NULL
df_componente$Max_RAM_Processo <- NULL
df_componente$Disco_Livre <- NULL
df_componente$Disco_Usado <- NULL
df_componente$Disco_Read_Count <- NULL
df_componente$Swap_Usado <- NULL
df_componente$RAM_RSS_Processos <- NULL
df_componente$Swap_Livre <- NULL
df_componente$UsoDisco <- NULL
df_componente$Rede_Bytes_Enviados <- NULL
df_componente$Rede_Pacotes_Enviados <- NULL
df_componente$Swap_Percent <- NULL
df_componente$Qtd_Threads <- NULL

matriz_componente <- cor(df_componente)

corrplot(matriz_componente,
         method = "color",
         type = "lower",
         addCoef.col = "black",
         number.cex = 0.3,
         tl.col = "black",
         tl.srt = 45,
         tl.cex = 0.5,
         diag = FALSE
)


# 1. Definindo o modelo linear múltiplo com variáveis selecionadas
modelo_ram <- lm(UsoRAM ~ Qtd_Processos + 
                   Rede_Bytes_Recebidos + 
                   Disco_Write_Count,
                 data = df_componente)

# 2. Analisando os resultados estatísticos do modelo
summary(modelo_ram)

# Modelo para prever o volume de dados escritos no disco
modelo_escrita_disco <- lm(Disco_Write_Bytes ~
                             Qtd_Processos + 
                             Disco_Read_Bytes, 
                           data = df_componente)

# Validar estatísticas no console
summary(modelo_escrita_disco)


# Interrupções na CPU
modelo_interrupcoes_cpu <- lm(CPU_Interrupts ~ Disco_Write_Count + 
                                Rede_Pacotes_Recebidos + 
                                UsoCPU_Geral, 
                              data = df_componente)

# Validar estatísticas no console
summary(modelo_interrupcoes_cpu)


# Modelo para prever a concorrência na CPU
modelo_ctx_switches <- lm(CPU_Ctx_Switches ~ Qtd_Processos + 
                            Rede_Pacotes_Recebidos + 
                            UsoRAM,
                          data = df_componente)

summary(modelo_ctx_switches)

# Modelo de chamadas no sistema
modelo_syscalls <- lm(CPU_Syscalls ~
                        Qtd_Processos +
                        Disco_Read_Bytes +
                        UsoRAM,
                      data = df_componente)


summary(modelo_syscalls)


# modelo de leitura de dados
modelo_leitura_disco_bytes <- lm(Disco_Read_Bytes ~ Rede_Bytes_Recebidos + 
                                   UsoRAM, 
                                 data = df_componente)

summary(modelo_leitura_disco_bytes)

# Modelo ram livre
modelo_ram_livre <- lm(RAM_Livre ~ Disco_Write_Count + 
                         Qtd_Processos, 
                       data = df_componente)

summary(modelo_ram_livre)

