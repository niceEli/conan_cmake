from conan import ConanFile # type: ignore
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps # type: ignore


class fatalEngineRecipe(ConanFile):
  name = "conan-cmake"
  version = "1.0.0"
  package_type = "application"

  # Optional metadata
  license = "MIT"
  author = "niceEli"

  # Binary configuration
  settings = "os", "compiler", "build_type", "arch"

  # Sources are located in the same place as this recipe, copy them to the recipe
  exports_sources = "CMakeLists.txt", "src/*"

  def requirements(self):
    self.requires("fmt/11.0.2")
    self.requires("glfw/3.4")
    self.requires("vulkan-headers/1.3.290.0")

  def layout(self):
    cmake_layout(self)

  def generate(self):
    deps = CMakeDeps(self)
    deps.generate()
    tc = CMakeToolchain(self)
    tc.generate()

  def build(self):
    cmake = CMake(self)
    cmake.configure()
    cmake.build()

  def package(self):
    cmake = CMake(self)
    cmake.install()

