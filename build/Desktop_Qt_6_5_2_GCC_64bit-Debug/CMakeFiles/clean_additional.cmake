# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/scc-app_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/scc-app_autogen.dir/ParseCache.txt"
  "scc-app_autogen"
  )
endif()
