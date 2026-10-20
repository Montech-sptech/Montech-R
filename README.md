# Montech-R
# ✈️ Validação de Dashboard AWS

Este repositório contém um script em R desenvolvido para analisar e validar os dados brutos de telemetria de servidores hospedados na AWS. O objetivo principal do projeto é comprovar matematicamente e visualmente se as métricas apresentadas na dashboard de monitoramento refletem a realidade operacional, além de identificar gargalos na infraestrutura.

## 🎯 Objetivos do Projeto

*   **Comprovação de Dados:** Extrair médias e picos de recortes específicos de tempo (ex: janelas de 5 minutos) para garantir que a dashboard calcula e exibe as informações corretamente.
*   **Análise de Estresse:** Identificar os limites máximos absolutos alcançados por cada servidor em termos de CPU, RAM e Disco, quantificando quantas vezes a operação entrou em estado de "Atenção" ou "Crítico".
*   **Análise de Sazonalidade:** Simular e estruturar a comparação de carga nos servidores entre dias úteis convencionais e períodos de alta demanda, como feriados e finais de semana.
*   **Visualização Gráfica:** Gerar evidências visuais claras do comportamento dos recursos computacionais ao longo do tempo.

## 🛠️ Tecnologias Utilizadas

O projeto foi desenvolvido inteiramente em **R**, utilizando pacotes modernos para manipulação de dados e geração de gráficos:
*   `dplyr`: Para manipulação de dados, agrupamentos, filtros e sumarizações de forma limpa e otimizada.
*   `ggplot2`: Para a criação de visualizações de dados profissionais e customizáveis.
*   `lubridate`: Para o tratamento e conversão eficiente de datas e séries temporais (`TimeStamp`).
*   `readr`: Para a importação rápida e segura de arquivos CSV.

## 📊 Resultados e Visualizações

Um dos principais entregáveis do script é a geração de gráficos comprobatórios. O gráfico gerado ilustra o uso de CPU do servidor ao longo do recorte de tempo analisado. 

Como podemos observar no resultado abaixo, o script plota a curva de processamento e traça uma linha vermelha tracejada no marco de 90%, que representa o limite crítico de operação. Durante o período analisado (20:30 às 20:45), houve um pico de processamento por volta das 20:33, mas o uso geral se manteve seguro e abaixo da margem crítica de falha.

![Gráfico de CPU](grafico_cpu.png)

## 🚀 Como executar o projeto

**Pré-requisitos:**
*   R e RStudio instalados.
*   Pacotes necessários instalados. Caso não os tenha, execute no console do R: 
    ```R
    install.packages(c("dplyr", "ggplot2", "lubridate", "readr"))
    ```

**Passo a passo:**
1. Clone este repositório para a sua máquina local.
2. Certifique-se de que o arquivo de dados bruto CSV está na mesma pasta/diretório em que o RStudio está operando.
3. Abra o script `.R` no RStudio.
4. Selecione todo o código e clique em **Run** (ou pressione `Ctrl + Enter`).
5. Os resultados das sumarizações aparecerão no console e o gráfico comprobatório será gerado na aba **Plots** do RStudio.
