library(foreach)
library(doParallel)
library(dplyr)
library(cit)
library(progress)
data <- read.csv("D:/临床数据/NHANES数据清洗/10年心因死亡数据.csv", check.names = FALSE)
L_factors <- data[, 7:21]
L_factors <- apply(L_factors, 2, function(x) as.factor(as.numeric(as.factor(x)) - 1))
L_continuous <- data[, 2:6, drop = FALSE]
L_continuous_colname <- colnames(L_continuous)
L <- cbind(L_factors, L_continuous)
G <- data[, 22:68]
T <- data[, 73, drop = TRUE]
L_colnames <- colnames(L) 
G_colnames <- colnames(G)
T_colname <- colnames(data)[73]
results_df <- data.frame(L_column = character(), G_column = character(), T_column = character(),
                         p_value = numeric())
num_L <- ncol(L)
num_G <- ncol(G)
num_T <- 1 
total_tasks <- num_L * num_G * num_T
pb <- progress_bar$new(
  format = "  进度 [:bar] :percent 已完成: :current/:total 预计剩余时间: :eta",
  total = total_tasks,
  clear = FALSE,
  width = 60
)
start_time <- Sys.time()
cl <- makeCluster(detectCores() - 2)
registerDoParallel(cl)
results <- foreach(l = 1:num_L, .combine = 'rbind', .packages = c('dplyr', 'cit')) %:%
  foreach(g = 1:num_G, .combine = 'rbind', .packages = c('dplyr', 'cit')) %dopar% {
    result <- tryCatch({
      cit.bp(L[, l], G[, g], T)
    }, error = function(e) {
      cat("Error in mediation analysis for L column", l, ", G column", g, ":", e$message, "\n")
      return(NULL)
    })
    L_colname <- L_colnames[l]
    G_colname <- G_colnames[g]
    if (!is.null(result)) {
      df <- data.frame(L_column = L_colname, G_column = G_colname, T_column = T_colname, p_value = result$p_cit)
    } else {
      df <- data.frame(L_column = L_colname, G_column = G_colname, T_column = T_colname, p_value = NA)
    }
    cat(sprintf("Completed L: %s, G: %s\n", L_colname, G_colname))
    pb$tick()
    return(df)
  }
stopCluster(cl)
results_df <- bind_rows(results)
end_time <- Sys.time()
cat("总时间:", difftime(end_time, start_time, units = "secs"), "\n")
print(results_df)
output_file_path <- "D:/临床数据/NHANES数据清洗/results_df_10年心因死亡数据.csv"
write.csv(results_df, output_file_path, row.names = FALSE)
cat("Results have been saved to", output_file_path, "\n")