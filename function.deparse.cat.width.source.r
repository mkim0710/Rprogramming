function.deparse.cat.width = function(x, width.cutoff=200) {
  # source("https://github.com/mkim0710/Rprogramming/raw/master/function.deparse.cat.width.source.r")
  cat(deparse(x, width.cutoff = width.cutoff), sep = "\n")
}

# > dput(1:30*2)
# c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 
# 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60)
# > function.deparse.cat.width(1:30*2)
# c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60)

