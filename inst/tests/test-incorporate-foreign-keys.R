context("incorporate_foreign_keys")

test_that("Read foreign key properly",{
	pkg <- read_data_package("../extdata/datapackage.json")
	table <- get_resource(pkg, "data3")	
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:6, 
																		labels=c(rep(NA_character_, 3),
																						 "test", "another", "final")), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)	
})

test_that("Single column factorizes properly",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-single"
		
	table <- get_resource(pkg, "data3")
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:6, 
																		labels=c(rep(NA_character_, 3),
																						 4:6)), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)		
	
})

test_that("Three column factorizes properly",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol2"
	
	table <- get_resource(pkg, "data3", name.column="C", cache=FALSE)
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:6, 
																		labels=c(rep(NA_character_, 3),
																						 "strA", "strB", "strC")), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)	
})


test_that("Three column factorizes on another column properly",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol2"
	
	table <- get_resource(pkg, "data3", name.column="B", cache=FALSE)
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:6, 
																		labels=c(rep(NA_character_, 3),
																						 "test", "another", "final")), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)	
})

test_that("Missing multi-col factors convert to NA",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol"
	
	table <- get_resource(pkg, "data3", name.column="B")
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:9, 
																		labels=c(rep(NA_character_, 6),
																						 "test", "another", "final")), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)	
})

test_that("Misnamed column errors",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol"
	
	expect_error(get_resource(pkg, "data3", cache=FALSE, name.columns="name"), "name.column value")		
})

test_that("Misnamed column as list errors",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol"
	
	suppressWarnings({
		expect_error(get_resource(pkg, "data3", cache=FALSE, name.columns=list(fileA="name")), "name.column value")		
	})
})


test_that("Missing resource name from column.name list warns but works",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol2"
	
	expect_warning(table <- get_resource(pkg, "data3", name.column=list(fileA="B"), cache=FALSE))
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:6, 
																		labels=c(rep(NA_character_, 3),
																						 "test", "another", "final")), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)	
})

test_that("Three column factorizes on another column properly",{
	pkg <- read_data_package("../extdata/datapackage.json")
	
	#modify schema to point foreign key to single data resource
	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol2"
	
	table <- get_resource(pkg, "data3", name.column="B", cache=FALSE)
	
	#Will warn that duplicated levels are going away
	suppressWarnings({
		expected <- data.frame(A=factor(4:6, 
																		levels=1:6, 
																		labels=c(rep(NA_character_, 3),
																						 "test", "another", "final")), 
													 B=c("level 4", "level 5", "level 6"), 
													 stringsAsFactors=FALSE)
	})
	expect_identical(table, expected)	
})

# 
# test_that("Cache properly considers name.column parameter",{
# 	pkg <- read_data_package("../extdata/datapackage.json")
# 	
# 	#modify schema to point foreign key to single data resource
# 	pkg$resources[[3]]$schema$fields[[1]]$foreignkey$resource <- "data-threecol2"
# 	
# 	table <- get_resource(pkg, "data3", name.column="C", cache=TRUE)
# 	
# 	#Will warn that duplicated levels are going away
# 	expect_warning({
# 		expected <- data.frame(A=factor(4:6, 
# 																		levels=1:6, 
# 																		labels=c(rep(NA_character_, 3),
# 																						 "strA", "strB", "strC")), 
# 													 B=c("level 4", "level 5", "level 6"), 
# 													 stringsAsFactors=FALSE)
# 	})
# 	expect_identical(table, expected)	
# 	
# 	table <- get_resource(pkg, "data3", name.column="B", cache=TRUE)
# 	
# 	#Will warn that duplicated levels are going away
# 	expect_warning({
# 		expected <- data.frame(A=factor(4:6, 
# 																		levels=1:6, 
# 																		labels=c(rep(NA_character_, 3),
# 																						 "test", "another", "final")), 
# 													 B=c("level 4", "level 5", "level 6"), 
# 													 stringsAsFactors=FALSE)
# 	})
# 	expect_identical(table, expected)	
# })