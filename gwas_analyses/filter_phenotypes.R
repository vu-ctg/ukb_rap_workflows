library(data.table)
library(dplyr)
data = fread("gestational_diabetes_tmp.csv")

i0 = data %>% 
  filter(participant.p4041_i0==0 | participant.p4041_i0==1) %>%
  select(participant.eid, participant.p4041_i0) %>%
  mutate(IID = participant.eid) %>%
  select(participant.eid, IID, participant.p4041_i0)

colnames(i0) = c("FID", "IID", "GestationalDiabetes")

i0$GestationalDiabetes[i0$GestationalDiabetes == 1] <- 2
i0$GestationalDiabetes[i0$GestationalDiabetes == 0] <- 1

write.csv(i0, "gestational_diabetes.pheno", quote = F, row.names = F)