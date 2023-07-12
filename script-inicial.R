#Depuração dos dados

#Comando para setar o local das tabelas na máquina
setwd("C:/Users/joeli/OneDrive - PMDF/Data Analitics/Analise_Exploratória/Trabalho")

#baixar o pacote para leitura dos arquivos csv

library(readr)
acidentes2018_todas_causas_tipos <- read_delim("acidentes2018_todas_causas_tipos.csv", 
                                               delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                               trim_ws = TRUE)

acidentes2019_todas_causas_tipos <- read_delim("acidentes2019_todas_causas_tipos.csv", 
                                               delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                               trim_ws = TRUE)

acidentes2020_todas_causas_tipos <- read_delim("acidentes2020_todas_causas_tipos.csv", 
                                               delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                               trim_ws = TRUE)

acidentes2021_todas_causas_tipos <- read_delim("acidentes2021_todas_causas_tipos.csv", 
                                               delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                               trim_ws = TRUE)

acidentes2022_todas_causas_tipos <- read_delim("acidentes2022_todas_causas_tipos.csv", 
                                               delim = ";", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
                                               trim_ws = TRUE)
#baixando pacotes para manuseio dos dados
install.packages("tidyverse")
library(tidyverse)
library(dplyr)

#Comando utilizado para unir os dados dos ano de 2018 a 2019
dadosUnidos <- bind_rows(acidentes2018_todas_causas_tipos,acidentes2019_todas_causas_tipos,acidentes2020_todas_causas_tipos, acidentes2021_todas_causas_tipos, acidentes2022_todas_causas_tipos )

# o comando bind_rows apresentou incongruência entre as colunas latitude
#Error in `bind_rows()`:
#  ! Can't combine `..1$latitude` <character> and `..3$latitude` <double>.
#A incompatibilidade está entre os anos 2018 e 2020
str(acidentes2018_todas_causas_tipos) #latitude character e longitude numeric
str(acidentes2020_todas_causas_tipos) #latitude double e longitude double
#Comando para modificar a coluna latitude
acidentes2020_todas_causas_tipos$latitude <- as.character(as.double(acidentes2020_todas_causas_tipos$latitude))
#Comando para unir os dados de acidentes
dadosUnidos <- bind_rows(acidentes2018_todas_causas_tipos,acidentes2019_todas_causas_tipos,acidentes2020_todas_causas_tipos, acidentes2021_todas_causas_tipos, acidentes2022_todas_causas_tipos )
#Confere a estrutura do Data frame
str(dadosUnidos)

#Confere se existem dados na
sum(is.na(dadosUnidos))
#[1] 783723
#Identifica quais colunas possuem valores
sapply(dadosUnidos, function(x) sum(is.na(x)))
# pesid = 169544, br = 5058, km = 5058, tipo_acidente = 96, classificacao_acidente = 1, id_veiculo = 1
# marca = 90875, ano_fabricacao = 112658, idade = 400400, regional, delegacia e uop = 4

#Transforma os dados da coluna causa_acidente em uma categórica
dadosUnidos$causa_acidente <- as.factor(dadosUnidos$causa_acidente)
class(dadosUnidos$causa_acidente)


#Cria um df com a quantidade de casos por causa de acidente em ordem decresente
causasFrequentes <- dadosUnidos %>%
  group_by(causa_acidente)%>%
  tally()%>%
  arrange(desc(n))