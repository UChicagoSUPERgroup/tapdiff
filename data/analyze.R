##### R CMD BATCH analyze.R

# to install packages
# in your terminal, run `$ R`
# then in the R console run:
# > install.packages('jsonlite')
# > install.packages('repolr')
# and follow the propmpts to select mirror

# Load packages
require(repolr)
require(plyr)
require(nlme)
require(car)
require(reporttools) # for multiple comparisons with fisher's exact
require(ggplot2) # for violin plots!
#require(ordinal)
#require(MASS)
#require(nnet)
#require(stringi)
#require(stringr)

# Options
options(stringsAsFactors = F)
###############################################################################
# Helper functions

# blase's helper function for comparing quant data
kwmagic <- function(vlist) {
	pvals <- lapply(vlist, function(v) {
		cat("###", v, "descriptive stats:\n")
		print(mysummary(data[[v]]))
		cat("mean\n")
		print(aggregate(data[[v]], list(interface=data[["interface"]]), mean ))
		cat("sd\n")
		print(aggregate(data[[v]], list(interface=data[["interface"]]), sd ))
		cat("median\n")
		print(aggregate(data[[v]], list(interface=data[["interface"]]), median ))
		kwformula <- as.formula(paste(v,"~ interface"))
		t <- kruskal.test(kwformula, data = data) 
		print(t)
		# if significant, do all pairwise comparisons
		if(t$p.value <= 0.05) {
			print(pairwise.wilcox.test(data[[v]], data[["interface"]], p.adjust.method = "holm", paired = FALSE))
			cat("\n\n")
		}
		return(t$p.value)
	})
	pvalscorrected <- p.adjust(pvals, method = "holm")
	m <- matrix(c(pvals, pvalscorrected), ncol=2, nrow=length(pvals))
	colnames(m) <- c("uncorrected-p", "corrected-p")
	rownames(m) <- vlist
	print("Omnibus test p-values:")
	print(m)
	cat("\n\n")
	#return(TRUE)
	#return(TRUE)
}

# blase's helper function for analyzing contingency tables where the response variable is 0,1
chisqmagic <- function(vlist) {
	pvals <- lapply(vlist, function(v) {
		cat("###", v, "table:\n")
		mytable <- table(data[[v]],data[["interface"]])
		print(mytable)
		print(round(100*prop.table(mytable,2),1))
		cat("\n\n")
		ft <- fisher.test(mytable)
		print(ft)
		# if significant, do all pairwise comparisons
		if(ft$p.value <= 0.05) {
			responsedata <- factor(data[[v]], levels=c(0,1),ordered=FALSE)
			grouping <- data[["interface"]] # already a factor
			#print(responsedata)
			#print(grouping)
			print(pairwise.fisher.test(responsedata, grouping, p.adjust.method = "holm"))
			cat("\n\n")
		}
		return(ft$p.value)
	})
	pvalscorrected <- p.adjust(pvals, method = "holm")
	m <- matrix(c(pvals, pvalscorrected), ncol=2, nrow=length(pvals))
	colnames(m) <- c("uncorrected-p", "corrected-p")
	rownames(m) <- vlist
	print("Omnibus test p-values:")
	print(m)
	cat("\n\n")
	#return(TRUE)
}

FormatPropTable <- function(intable, dec = 1) {
  # Print a prop.table with given number of decimal places and percent sign
  y <- paste(as.character(round(intable * 100, dec)), "%", sep = "")
  return(y)
}

RecodeVector <- function(vector, oldvalues, newvalues) {
  # Function for recoding values of a vector based on a vector of matching oldvalues and newvalues
  # Ex. oldvalues = c("Male", "Female") and newvalues = c("M", "F") will change all instances of "Male" and "Female" in the given vector with "M" and "F", leaving the other values alone
  if (length(oldvalues) != length(newvalues)) {
    stop("oldvalues and newvalues must be the same length!")
  }
  
  # Make copy of vector and replace values
  vec2 <- vector  
  for (i in seq_along(oldvalues)) {
    vec2[which(vec2 %in% oldvalues[i])] <- newvalues[i]
  }
  
  return(vec2)
}

mysummary <- function(vector, na.rm = FALSE, rnd = 1){
  results <- c(round(summary(vector),rnd), 'Std. Dev' = round(sd(vector, na.rm), rnd))
  return(results)
}

myproptable <- function(vector, na.rm = FALSE, round = 2){
   return(prop.table(table(vector)))
}

#bentable <- function(df, colofinterest, num_vals) {
#    pro <- matrix(0, nrow=6, ncol=num_vals)
#    lev <- levels(df[colofinterest])
#    fname <- paste(colofinterest,".csv",sep="")
#    #new_df = count(df, colofinterest)
#    #colnames(new_df)[colnames(new_df)=="freq"] <- "all"
#    #new_df <- new_df[1:num_vals,]
#    for (val in c(1,2,3,4,5,6)) {
#        x <- as.character(df[as.character(df$condition) == as.character(val),colnames(df)==colofinterest])
#    #print(x)
#        for (l in c(-3,-2,-1,0,1,2,3)) {
#            pro[val,l+4] <- sum(x == as.character(l))
#        #newer_df = count(x, colofinterest)
#        #newer_df <- newer_df[1:num_vals,]
#        #new_df[paste("c",val,sep="")] <- newer_df["freq"]
#        #y = count(mtcars, 'gear')
#        }
#    }
#    write.csv(pro, fname)
#    #close(fileConn)
#}


###############################################################################
# Initialize data

# Assume current directory is the source file location

# Save results
sink("results.log")

# Load data sources into tables
data <- read.csv(file = "prgmdiff_results.csv", header=TRUE, na.strings = c("NA", "#N/A"))

# Convert blanks or #N/A to NA
for (col in colnames(data)) {
  data[[col]] <- ifelse(data[[col]] == "" | data[[col]] == "#N/A",
                           rep(NA, nrow(data)),
                           data[[col]])
}

cat("Number of rows in data:", nrow(data), "\n")
cat("Number of unique id numbers in data:", length(unique(data$prolific_pid)), "\n")
cat("\n\n")

data$interface <- factor(data$interface,levels=c("Rules","Text-Diff","Flowcharts","Questions","Property-Diff"),ordered=FALSE)
data$tut <- data$tut1 + data$tut2 + data$tut3
# age: 1: 18-24, 2: 25-34, 3: 35-44, 4: 45-54, 5: 55-64, 6: 65-74, 7: 75 or older, 8: prefer not to answer
data$agebinned <- data$age
data$age[data$age==1] <- "18-24"
data$age[data$age==2] <- "25-34"
data$age[data$age==3] <- "35-44"
data$age[data$age==4] <- "45-54"
data$age[data$age==5] <- "55-64"
data$age[data$age==6] <- "65-74"
data$age[data$age==7] <- "75 or older"
data$age[data$age==8] <- "prefernot answer"
data$age <- factor(data$age,levels=c("18-24","25-34","35-44","45-54","55-64","65-74","75 or older","prefernot"),ordered=FALSE)
data$agebinned[data$agebinned==1] <- "18-24"
data$agebinned[data$agebinned==2] <- "25-34"
data$agebinned[data$agebinned>=3] <- "35+"
data$agebinned <- factor(data$agebinned,levels=c("25-34","18-24","35+"),ordered=FALSE)
# gender: 1 - Woman, 2 - Man, 3 - Non-binary, 4 - self-describe, 5 - prefer not to answer
data$gender_mc[data$gender_mc==1] <- "Woman"
data$gender_mc[data$gender_mc==2] <- "Man"
data$gender_mc[data$gender_mc==3] <- "Non-binary"
data$gender_mc[data$gender_mc==4] <- "Self-describe"
data$gender_mc[data$gender_mc==5] <- "prefernot"
data$gender_mcbinned <- data$gender_mc
data$gender_mc <- factor(data$gender_mc,levels=c("Woman","Man","Non-binary","Self-describe","prefernot"),ordered=FALSE)
data$gender_mcbinned <- factor(data$gender_mcbinned,levels=c("Woman","Man","Non-binary"),ordered=FALSE)
# education: 1 - less than hs, 2 - hs grad, 3 - some college, 4 - 2yr college, 5 - 4yr college, 6 - masters/professional degree, 7 - doctorate, 8 - prefer not to answer
data$educationbinned <- data$education
data$education[data$education==1] <- "less than hs"
data$education[data$education==2] <- "hs grad"
data$education[data$education==3] <- "some college"
data$education[data$education==4] <- "2yrcollege"
data$education[data$education==5] <- "4yrcollege"
data$education[data$education==6] <- "ms"
data$education[data$education==7] <- "doctorate"
data$education[data$education==8] <- "prefernot"
data$education <- factor(data$education,levels=c("less than hs","hs grad","some college","2yrcollege","4yrcollege","ms","doctorate","prefernot"),ordered=FALSE)
data$educationbinned[data$educationbinned==2] <- "hs grad"
data$educationbinned[data$educationbinned==3] <- "some college"
data$educationbinned[data$educationbinned==4] <- "collegedegree"
data$educationbinned[data$educationbinned==5] <- "collegedegree"
data$educationbinned[data$educationbinned==6] <- "msphd"
data$educationbinned[data$educationbinned==7] <- "msphd"
data$educationbinned <- factor(data$educationbinned,levels=c("hs grad","some college","collegedegree","msphd"),ordered=FALSE)
# any cs experience (combined): TRUE - yes, FALSE - no
data$cs = (data$cs_position == 1 | data$cs_class == 1 | data$cs_experience == 1)
data$cs <- factor(data$cs,levels=c(TRUE,FALSE),ordered=FALSE)
# cs_position: 1 - yes, 2 - no, 3 - prefer not to answer
data$cs_positionbinned <- data$cs_position
data$cs_position[data$cs_position==1] <- "yes"
data$cs_position[data$cs_position==2] <- "no"
data$cs_position[data$cs_position==3] <- "prefernot"
data$cs_position <- factor(data$cs_position,levels=c("no","yes","prefernot"),ordered=FALSE)
data$cs_positionbinned[data$cs_positionbinned==1] <- "yes"
data$cs_positionbinned[data$cs_positionbinned==2] <- "no"
data$cs_positionbinned[data$cs_positionbinned==3] <- "no"
data$cs_positionbinned <- factor(data$cs_positionbinned,levels=c("no","yes"),ordered=FALSE)
# cs_class: 1 - yes, 2 - no, 3 - prefer not to answer
data$cs_classbinned <- data$cs_class
data$cs_class[data$cs_class==1] <- "yes"
data$cs_class[data$cs_class==2] <- "no"
data$cs_class[data$cs_class==3] <- "prefernot"
data$cs_class <- factor(data$cs_class,levels=c("no","yes","prefernot"),ordered=FALSE)
data$cs_classbinned[data$cs_classbinned==1] <- "yes"
data$cs_classbinned[data$cs_classbinned==2] <- "no"
data$cs_classbinned[data$cs_classbinned==3] <- "no"
data$cs_classbinned <- factor(data$cs_classbinned,levels=c("no","yes"),ordered=FALSE)
# cs_experience: 1 - yes, 2 - no, 3 - prefer not to answer
data$cs_experiencebinned <- data$cs_experience
data$cs_experience[data$cs_experience==1] <- "yes"
data$cs_experience[data$cs_experience==2] <- "no"
data$cs_experience[data$cs_experience==3] <- "prefernot"
data$cs_experience <- factor(data$cs_experience,levels=c("no","yes","prefernot"),ordered=FALSE)
data$cs_experiencebinned[data$cs_experiencebinned==1] <- "yes"
data$cs_experiencebinned[data$cs_experiencebinned==2] <- "no"
data$cs_experiencebinned[data$cs_experiencebinned==3] <- "no"
data$cs_experiencebinned <- factor(data$cs_experiencebinned,levels=c("no","yes"),ordered=FALSE)
# ifttt_familiarity: 1 - yes, 2 - no, 3 - not sure
data$ifttt_familiaritybinned <- data$ifttt_familiarity
data$ifttt_familiarity[data$ifttt_familiarity==1] <- "yes"
data$ifttt_familiarity[data$ifttt_familiarity==2] <- "no"
data$ifttt_familiarity[data$ifttt_familiarity==35] <- "notsure"
data$ifttt_familiarity <- factor(data$ifttt_familiarity,levels=c("no","yes","notsure"),ordered=FALSE)
data$ifttt_familiaritybinned[data$ifttt_familiaritybinned==1] <- "yes"
data$ifttt_familiaritybinned[data$ifttt_familiaritybinned==2] <- "no"
data$ifttt_familiaritybinned[data$ifttt_familiaritybinned==35] <- "no"
data$ifttt_familiaritybinned <- factor(data$ifttt_familiaritybinned,levels=c("no","yes"),ordered=FALSE)
# owned_iot_mc: 1 - yes, 2 - no, 3 - prefer not to answer
data$owned_iot_mcbinned <- data$owned_iot_mc
data$owned_iot_mc[data$owned_iot_mc==1] <- "yes"
data$owned_iot_mc[data$owned_iot_mc==2] <- "no"
data$owned_iot_mc[data$owned_iot_mc==3] <- "prefernot"
data$owned_iot_mc <- factor(data$owned_iot_mc,levels=c("yes","no","prefernot"),ordered=FALSE)
data$owned_iot_mcbinned[data$owned_iot_mcbinned==1] <- "yes"
data$owned_iot_mcbinned[data$owned_iot_mcbinned==2] <- "no"
data$owned_iot_mcbinned[data$owned_iot_mcbinned==3] <- "no"
data$owned_iot_mcbinned <- factor(data$owned_iot_mcbinned,levels=c("yes","no"),ordered=FALSE)
# count how many times one person used the program button
data$prgm_button <- data$task_1_used_prgm_button + data$task_2_used_prgm_button + data$task_3_used_prgm_button + data$task_4_used_prgm_button + data$task_7_used_prgm_button + data$task_12_used_prgm_button
# sum the timing
data$totaltime <- data$task_1_time_ms + data$task_2_time_ms + data$task_3_time_ms + data$task_4_time_ms + data$task_7_time_ms + data$task_12_time_ms
# count how many programs one person got correct
data$totalcorrect <- data$task_1_correct + data$task_2_correct + data$task_3_correct + data$task_4_correct + data$task_7_correct + data$task_12_correct
# tabulate SUS score... traditionally done with 5 pt scales but 7 is ok https://measuringu.com/scale-points/
# also the scale is kind of backwards... 7pt-likert: 6 - strongly agree (too inconsistent), 12 - strongly disagree
# so positive statements should be 12-x and negative ones should be x-6
data$sus <- 100/60*((12-data$sus_frequent) + (data$sus_complex-6) + (12-data$sus_easy) + (data$sus_support-6) + (12-data$sus_integrated) + (data$sus_inconsistency-6) + (12-data$sus_quickly) + (data$sus_cumbersome-6) + (12-data$sus_confident) + (data$sus_learn-6))
#confidence	7pt-likert: 1 - strongly agree (confident), 7 - strongly disagree
data$confidence_summed <- data$confidence_1 + data$confidence_2 + data$confidence_3 + data$confidence_4 + data$confidence_7 + data$confidence_12
#demanding	7pt-likert: 1 - strongly agree (demanding), 7 - strongly disagree
data$demanding_summed <- data$demanding_1 + data$demanding_2 + data$demanding_3 + data$demanding_4 + data$demanding_7 + data$demanding_12
#helpful	7pt-likert: 1 - strongly agree (helpful), 7 - strongly disagree
data$helpful_summed <- data$helpful_1 + data$helpful_2 + data$helpful_3 + data$helpful_4 + data$helpful_7 + data$helpful_12

attach(data)

cat("##########################################################\n")
cat("############################ DEMOGRAPHICS\n")
cat("##########################################################\n")

cat("### Overview of interface:\n")
mytable <- table(interface)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of tutorial questions answered correctly:\n")
mytable <- table(tut)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of age:\n")
mytable <- table(age)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of gender_mc:\n")
mytable <- table(gender_mc)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of education:\n")
mytable <- table(education)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of CS (combined):\n")
mytable <- table(cs)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of cs_position:\n")
mytable <- table(cs_position)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of cs_class:\n")
mytable <- table(cs_class)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of cs_experience:\n")
mytable <- table(cs_experience)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of ifttt_familiarity:\n")
mytable <- table(ifttt_familiarity)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("### Overview of owned_iot_mc:\n")
mytable <- table(owned_iot_mc)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

cat("##########################################################\n")
cat("############################ USE OF PROGRAM BUTTON\n")
cat("##########################################################\n")

chisqmagic(c("task_1_used_prgm_button", "task_2_used_prgm_button", "task_3_used_prgm_button", "task_4_used_prgm_button", "task_7_used_prgm_button", "task_12_used_prgm_button"))

cat("### how many times a single person used the program button:\n")
summary(prgm_button)
mytable <- table(prgm_button)
print(mytable)
round(100*prop.table(mytable),1)
cat("\n\n")

kwmagic(c("prgm_button"))

# box and violin plot
pdf("prgmbutton.pdf", height=4.5, width=8) 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$prgm_button, cex.main=2, pch = 16,frame = FALSE, xlab = "Interface", ylab = "Number of Tasks", col = "#D3D3D3", boxwex=0.5)
#ggplot(data, aes(x=interface, y=prgm_button)) + geom_violin()
axis(1, at=1:5, labels=c("Rules","Text-Diff","Outcome-Diff:\nFlowcharts","Outcome-Diff:\nQuestions","Property-Diff"))
dev.off() 

# build a regression model (poisson because this is count data)
buttonfullmodel <- glm(prgm_button ~ interface + tut + agebinned + gender_mcbinned + educationbinned + cs_positionbinned + cs_classbinned + cs_experiencebinned + ifttt_familiaritybinned + owned_iot_mcbinned, data=data, family="poisson")
print("Full model:")
summary(buttonfullmodel)
buttonsmallmodel <- step(buttonfullmodel, direction = "backward", trace=FALSE)
print("Parsimonious model:")
summary(buttonsmallmodel)



cat("##########################################################\n")
cat("############################ TIMING\n")
cat("##########################################################\n")

# analyze whether times varied
kwmagic(c("totaltime"))

# analyze whether times varied
kwmagic(c("task_1_time_ms", "task_2_time_ms", "task_3_time_ms", "task_4_time_ms", "task_7_time_ms", "task_12_time_ms"))

# box and violin plot
pdf("totaltime.pdf") 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$totaltime/1000/60, cex.main=2, pch = 16,frame = FALSE, xlab = "Interface", ylab = "Total time (minutes)", col = "#D3D3D3")
#ggplot(data, aes(x=interface, y=totaltime)) + geom_violin()
dev.off() 

# build a regression model
timefullmodel <- glm(totaltime ~ interface + tut + agebinned + gender_mcbinned + educationbinned + cs_positionbinned + cs_classbinned + cs_experiencebinned + ifttt_familiaritybinned + owned_iot_mcbinned, data=data, family="gaussian")
print("Full model:")
summary(timefullmodel)
timesmallmodel <- step(timefullmodel, direction = "backward", trace=FALSE)
print("Parsimonious model:")
summary(timesmallmodel)

cat("##########################################################\n")
cat("############################ CORRECTNESS\n")
cat("##########################################################\n")
# analyze whether total number correct varied
kwmagic(c("totalcorrect"))

# build a regression model (poisson because this is count data)
correctnessfullmodel <- glm(totalcorrect ~ interface + tut + agebinned + gender_mcbinned + educationbinned + cs_positionbinned + cs_classbinned + cs_experiencebinned + ifttt_familiaritybinned + owned_iot_mcbinned, data=data, family="poisson")
print("Full model:")
summary(correctnessfullmodel)
correctnesssmallmodel <- step(correctnessfullmodel, direction = "backward", trace=FALSE)
print("Parsimonious model:")
summary(correctnesssmallmodel)

#box and violin plot
pdf("totalcorrect.pdf", height=4.5, width=8) 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$totalcorrect, cex.main=2, pch = 16, frame = FALSE, xlab = "Interface", ylab = "Number of Tasks", col = "#D3D3D3", boxwex=0.5)
axis(1, at=1:5, labels=c("Rules","Text-Diff","Outcome-Diff:\nFlowcharts","Outcome-Diff:\nQuestions","Property-Diff"))
#ggplot(data, aes(x=interface, y=totalcorrect)) + geom_violin()
dev.off() 

chisqmagic(c("task_1_correct", "task_2_correct", "task_3_correct", "task_4_correct", "task_7_correct", "task_12_correct"))

cat("##########################################################\n")
cat("############################ SUS\n")
cat("##########################################################\n")

# analyze whether times varied
kwmagic(c("sus"))

# box and violin plot
# use pdf(... width=6, height=6) for dimensions
pdf("SUS.pdf") 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$sus, cex.main=2, pch = 16, main="SUS Score", frame = FALSE, xlab = "Interface", ylab = "SUS Score", col = "#D3D3D3", ylim = c(0, 100))
#ggplot(data, aes(x=interface, y=sus)) + geom_violin()
dev.off() 

cat("##########################################################\n")
cat("############################ CONFIDENCE\n")
cat("##########################################################\n")
# DON'T FORGET THAT SMALLER NUMBERS ARE MORE CONFIDENT
kwmagic(c("confidence_summed"))

# box and violin plot
pdf("confidence.pdf") 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$confidence_summed, cex.main=2, pch = 16,frame = FALSE, xlab = "Interface", ylab = "Confidence (summed across tasks)", col = "#D3D3D3")
#ggplot(data, aes(x=interface, y=confidence_summed)) + geom_violin()
dev.off() 

# build a regression model (poisson because this is count data)
confidencefullmodel <- glm(confidence_summed ~ interface + tut + agebinned + gender_mcbinned + educationbinned + cs_positionbinned + cs_classbinned + cs_experiencebinned + ifttt_familiaritybinned + owned_iot_mcbinned, data=data, family="gaussian")
print("Full model:")
summary(confidencefullmodel)
confidencesmallmodel <- step(confidencefullmodel, direction = "backward", trace=FALSE)
print("Parsimonious model:")
summary(confidencesmallmodel)

kwmagic(c("confidence_1", "confidence_2", "confidence_3", "confidence_4", "confidence_7", "confidence_12"))

cat("##########################################################\n")
cat("############################ DEMANDING\n")
cat("##########################################################\n")
# DON'T FORGET THAT SMALLER NUMBERS ARE MORE DEMANDING
kwmagic(c("demanding_summed"))

# box and violin plot
pdf("demanding.pdf") 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$demanding_summed, cex.main=2, pch = 16,frame = FALSE, xlab = "Interface", ylab = "Demanding (summed across tasks)", col = "#D3D3D3")
#ggplot(data, aes(x=interface, y=demanding_summed)) + geom_violin()
dev.off()

# build a regression model (poisson because this is count data)
demandingfullmodel <- glm(demanding_summed ~ interface + tut + agebinned + gender_mcbinned + educationbinned + cs_positionbinned + cs_classbinned + cs_experiencebinned + ifttt_familiaritybinned + owned_iot_mcbinned, data=data, family="gaussian")
print("Full model:")
summary(demandingfullmodel)
demandingsmallmodel <- step(demandingfullmodel, direction = "backward", trace=FALSE)
print("Parsimonious model:")
summary(demandingsmallmodel)

kwmagic(c("demanding_1", "demanding_2", "demanding_3", "demanding_4", "demanding_7", "demanding_12"))

cat("##########################################################\n")
cat("############################ HELPFUL\n")
cat("##########################################################\n")
# DON'T FORGET THAT SMALLER NUMBERS ARE MORE HELPFUL
kwmagic(c("helpful_summed"))

# box and violin plot
pdf("helpful.pdf") 
par(font.axis=2, font.lab=2, cex.axis=0.95, cex.lab=1.4, mgp=c(2.75,1,0))
plot(x = data$interface, y = data$helpful_summed, cex.main=2, pch = 16,frame = FALSE, xlab = "Interface", ylab = "Helpful (summed across tasks)", col = "#D3D3D3")
#ggplot(data, aes(x=interface, y=helpful_summed)) + geom_violin()
dev.off()

# build a regression model (poisson because this is count data)
helpfulfullmodel <- glm(helpful_summed ~ interface + tut + agebinned + gender_mcbinned + educationbinned + cs_positionbinned + cs_classbinned + cs_experiencebinned + ifttt_familiaritybinned + owned_iot_mcbinned, data=data, family="gaussian")
print("Full model:")
summary(helpfulfullmodel)
helpfulsmallmodel <- step(helpfulfullmodel, direction = "backward", trace=FALSE)
print("Parsimonious model:")
summary(helpfulsmallmodel)

kwmagic(c("helpful_1", "helpful_2", "helpful_3", "helpful_4", "helpful_7", "helpful_12"))


###############################################################################
# Export data
sink()

