#   Download qualtrics data into R
#    Copyright (C) 2017 Jasper Ginn

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Retrieve a data frame containing question IDs and labels
#'
#' @param surveyID String. Unique ID for the survey you want to download. Returned as 'id' by the \link[qualtRics]{getSurveys} function.
#' @param root_url String. Base url for your institution (see \url{https://api.qualtrics.com/docs/csv}. You need to supply this url. Your query will NOT work without it.).
#'
#' @seealso See \url{https://api.qualtrics.com/docs} for documentation on the Qualtrics API.
#' @author Jasper Ginn
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr add_headers
#' @export
#' @examples
#' \dontrun{
#' registerApiKey("<YOUR-QUALTRICS-API-KEY>")
#' # Retrieve a list of surveys
#' surveys <- getSurveys(root_url = "https://leidenuniv.eu.qualtrics.com")
#'                       # URL is for my own institution.
#'                       # Substitute with your own institution's url
#' # Retrieve questions for a survey
#' questions <- getSurveyQuestions(surveyID = surveys$id[6],
#'                                 root_url = "https://leidenuniv.eu.qualtrics.com")
#' # Retrieve a single survey, filtering for questions I want.
#' mysurvey <- getSurvey(surveyID = surveys$id[6],
#'                       root_url = "https://leidenuniv.eu.qualtrics.com",
#'                       save_dir = tempdir(),
#'                       includedQuestionIds = c("QID1", "QID2", "QID3"),
#'                       verbose=TRUE)
#' }

getSurveyQuestions <- function(surveyID,
                               root_url = "https://yourdatacenterid.qualtrics.com") {
  # Check params
  checkParams(root_url=root_url, check_qualtrics_api_key=TRUE)
  # Function-specific API stuff
  root_url <- appendRootUrl(root_url, "surveys")
  # Add survey id
  root_url <- paste0(root_url,
                     "/",
                     surveyID)
  # GET request to download metadata
  resp <- qualtricsApiRequest("GET", root_url)
  # Get question information and map
  qi <- resp$result$questions
  # Add questions
  quest <- data.frame(
    "qid" = names(qi),
    "question" = sapply(qi, function(x) x$questionText),
    stringsAsFactors = FALSE
  )
  # Row names
  row.names(quest) <- 1:nrow(quest)
  # Return
  return(quest)
}