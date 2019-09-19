set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

if(MINGW OR CYGWIN OR WIN32)
    set(SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(SEARCH_CMD which)
endif()

set(TOOLCHAIN_PREFIX arm-none-eabi)

# Find XSDK
execute_process(
  COMMAND ${SEARCH_CMD} xsdk
  OUTPUT_VARIABLE XSDK_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )

# Find the base path to the Xilinx tools
STRING(REGEX REPLACE "/bin/xsdk$" "" XIL_PATH ${XSDK_PATH})

set(CMAKE_SYSROOT ${XIL_PATH}/gnu/aarch32/lin/gcc-arm-none-eabi)
set(TOOL_BIN_PATH "${CMAKE_SYSROOT}/bin")

# Without that flag CMake is not able to pass test compilation check
if (${CMAKE_VERSION} VERSION_EQUAL "3.6.0" OR ${CMAKE_VERSION} VERSION_GREATER "3.6")
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
else()
    set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
endif()

set(CMAKE_C_COMPILER   ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_ASM_COMPILER ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_OBJCOPY      ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL    ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-size CACHE INTERNAL "size tool")


# Extract the version of the compiler
file(GLOB VER_NUM ${CMAKE_SYSROOT}/lib/gcc/${TOOLCHAIN_PREFIX}/*)

# Xilinx-specific include include directories
set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES
    "${CMAKE_SYSROOT}/${TOOLCHAIN_PREFIX}/include"
    "${CMAKE_SYSROOT}/${TOOLCHAIN_PREFIX}/libc/usr/include"
    "${CMAKE_SYSROOT}/lib/gcc/${TOOLCHAIN_PREFIX}/${VER_NUM}/include"
    "${CMAKE_SYSROOT}/lib/gcc/${TOOLCHAIN_PREFIX}/${VER_NUM}/include-fixed"
  )
set(CMAKE_ASM_STANDARD_INCLUDE_DIRECTORES ${CMAKE_C_STANDARD_INCLUDE_DIRECTORIES})
# Xilinx-specific library directories



# Xilinx-specific linker flags
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--start-group,-lxil,-lgcc,-lc,--end-group")


set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
