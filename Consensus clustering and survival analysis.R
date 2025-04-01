library(ConsensusClusterPlus)
data <- read.csv("D:/临床数据/NHANES数据清洗/共识聚类矩阵-10年心因死亡-LR+预测概率-10.csv", check.names = FALSE, row.names = 1)
print(data)
data <- as.matrix(data)
results <- ConsensusClusterPlus(
  data,                              
  maxK = 6,
  reps = 1000, 
  pItem = 0.8, 
  pFeature = 1,                     
  clusterAlg = "km",            
  distance = "euclidean", 
  seed = 123                   
)
k3_result <- results[[3]]$consensusClass
k3_sample_info <- as.data.frame(k3_result)
k3_sample_info$SEQN <- rownames(k3_sample_info)
k3_sample_info$SEQN <- as.integer(k3_sample_info$SEQN)
data2 <- read.csv("D:/临床数据/NHANES数据清洗/10年心因死亡数据.csv", check.names = FALSE)
merged_data <- merge(k3_sample_info, data2, by = "SEQN")
type_counts <- table(merged_data$k3_result)
print(type_counts)
output_dir <- "D:/临床数据/NHANES数据清洗"
output_file <- file.path(output_dir, "分群信息-LR-前10特征.csv")
write.csv(merged_data, file = output_file, row.names = FALSE)
library(survival)
library(survminer)
surv_object <- Surv(time = merged_data$permth_exm, event = merged_data$`10 year heart death`)
fit <- survfit(surv_object ~ k3_result, data = merged_data)
ggsurvplot(
  fit, data = merged_data, pval = TRUE,
  legend.title = "Subgroup of cardiac-related mortality",
  legend.labs = c("Subgroup 1 (n=289)", "Subgroup 2 (n=242)", "Subgroup 3 (n=238)"),
  palette = c("red", "blue", "green"),
  xlab = "Months",
  ylab = "Probability of survival",
  pval.size = 5,                               
  ggtheme = theme_minimal() +                 
    theme(
      axis.title.x = element_text(size = 12), 
      axis.title.y = element_text(size = 12),  
      panel.grid = element_blank(),           
      axis.line = element_line(linewidth = 0.5)
    ),
  xlim = c(0, 120) ,
  ylim = c(0, 1) ,
)