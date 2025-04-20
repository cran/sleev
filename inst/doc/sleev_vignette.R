## ----include=FALSE------------------------------------------------------------
# Redirect to pre-rendered PDF (static)
if (file.exists("../../inst/doc/sleev_vignette.pdf")) {
  cat("\\begin{center}\n")
  cat("\\fbox{\\includegraphics[width=0.9\\textwidth]{../../inst/doc/sleev_vignette.pdf}}\n") 
  cat("\\end{center}")
} else {
  cat("Vignette not found. Please reinstall the package.")
}

