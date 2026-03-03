devtools::load_all()

df <- nwaa_water_use(
  model_id = "wu-irrigation-wd",
  variable_ids = c("irrwdgw", "irrwdsw", "irrwdtot"),
  location_type = "countycd",
  location_id = "06029",
  time_res = "annualwy",
  range = "custom",
  start = "2001",
  end = "2020",
  intersection = "overlap",
  format = "csv",
  quiet = FALSE
)

head(df)

devtools::install()
devtools::document()
devtools::install(build = TRUE)
list.files("man")

?nwaa
devtools::load_all()
?nwaa_water_use

#Github
usethis::use_github()
