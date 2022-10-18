cmake_minimum_required(VERSION 3.11)

project(SimpleNES
    LANGUAGES CXX
    VERSION 0.1.0
)

add_subdirectory(smk)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Choose the type of build, options are: Debug Release."
        FORCE)
endif(NOT CMAKE_BUILD_TYPE)

set(BUILD_STATIC FALSE CACHE STRING "Set this to link external libraries statically")

if(CMAKE_COMPILER_IS_GNUCXX OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra -g")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
endif()

# Add directory containing FindSFML.cmake to module path
# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/;${CMAKE_MODULE_PATH};${CMAKE_SOURCE_DIR}")

# Add sources
# file(GLOB SOURCES
# "${PROJECT_SOURCE_DIR}/main.cpp"
# "${PROJECT_SOURCE_DIR}/src/*.cpp"
# )
set(SOURCES
    main.cpp
    src/Cartridge.cpp
    src/Controller.cpp
    src/CPU.cpp
    src/Emulator.cpp
    src/KeybindingsParser.cpp
    src/Log.cpp
    src/MainBus.cpp
    src/Mapper.cpp
    src/MapperAxROM.cpp
    src/MapperCNROM.cpp
    src/MapperColorDreams.cpp
    src/MapperGxROM.cpp
    src/MapperMMC3.cpp
    src/MapperNROM.cpp
    src/MapperSxROM.cpp
    src/MapperUxROM.cpp
    src/PictureBus.cpp
    src/PPU.cpp
    src/VirtualScreen.cpp
)

# Copy keybindings.conf
file(COPY keybindings.conf DESTINATION .)

# Will add __FILENAME__ macros for all source files, which is the filename without full find_path
# Courtesy of SO
function(define_file_basename_for_sources targetname)
    get_target_property(source_files "${targetname}" SOURCES)

    foreach(sourcefile ${source_files})
        # Get source file's current list of compile definitions.
        get_property(defs SOURCE "${sourcefile}"
            PROPERTY COMPILE_DEFINITIONS)

        # Add the FILE_BASENAME=filename compile definition to the list.
        get_filename_component(basename "${sourcefile}" NAME)
        list(APPEND defs "__FILENAME__=\"${basename}\"")

        # Set the updated compile definitions on the source file.
        set_property(
            SOURCE "${sourcefile}"
            PROPERTY COMPILE_DEFINITIONS ${defs})
    endforeach()
endfunction()

# Find SFML
# if(SFML_OS_WINDOWS AND SFML_COMPILER_MSVC)
# find_package(SFML 2 COMPONENTS main audio graphics window system REQUIRED)
# else()
# find_package(SFML 2 COMPONENTS audio graphics window system REQUIRED)
# endif()

# if(SFML_FOUND)
# include_directories(${SFML_INCLUDE_DIR})
# else()
# set(SFML_ROOT "" CACHE PATH "SFML top-level directory")
# message("\nSFML directory not found. Set SFML_ROOT to SFML's top-level path (containing \"include\" and \"lib\" directories).")
# message("Make sure the SFML libraries with the same configuration (Release/Debug, Static/Dynamic) exist.\n")
# endif()
add_executable(${PROJECT_NAME} ${SOURCES})

# Specify include Directory
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_DIR}/include)

# target_link_libraries(SimpleNES ${SFML_LIBRARIES} ${SFML_DEPENDENCIES})
target_link_libraries(${PROJECT_NAME} PRIVATE smk)

set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 11)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD_REQUIRED ON)

# Set static if BUILD_STATIC is set
if(BUILD_STATIC)
    # set(SFML_STATIC_LIBRARIES TRUE)

    # Link libgcc and libstc++ statically as well
    if(CMAKE_COMPILER_IS_GNUCXX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++ -static-libgcc")
    endif()
endif()

# Detect emscripten is used.
if(CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
    target_link_libraries(${PROJECT_NAME} PRIVATE -lidbfs.js)

    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " -s DEMANGLE_SUPPORT=1")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " -s DISABLE_EXCEPTION_CATCHING=2")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " -s WASM=1")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " -s TOTAL_MEMORY=134217728")

    # Release flags
    # set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " --closure 1")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " --js-opts 3")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " --llvm-lto 3")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " --llvm-opts 3")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " -O3")
    set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS " -flto")

    # Copy the index.html and css files.
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/src/index.html
        ${CMAKE_CURRENT_BINARY_DIR}/index.html
    )

    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/src/style.css
        ${CMAKE_CURRENT_BINARY_DIR}/style.css
    )
endif()

define_file_basename_for_sources(${PROJECT_NAME})
