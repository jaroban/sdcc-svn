@echo off & perl -x %0 & pause & exit
#!perl
use strict;
use warnings;
use Data::GUID;

my @C_FILES = qw|
    tinibios.c memcpyx.c lcd390.c i2c390.c rtc390.c putchar.c gptr_cmp.c
    atomic_flag_test_and_set.c atomic_flag_clear.c
|;

my @object_files;

open(my $fh, '>', "ds390_lib.vcxproj") or die $!;

print $fh <<END;
<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <ItemGroup Label="ProjectConfigurations">
    <ProjectConfiguration Include="Debug|Win32">
      <Configuration>Debug</Configuration>
      <Platform>Win32</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Release|Win32">
      <Configuration>Release</Configuration>
      <Platform>Win32</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Debug|x64">
      <Configuration>Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Release|x64">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>
  <ItemGroup>
END

foreach my $c_source (@C_FILES)
{
    my $rel_file = $c_source;
    $rel_file =~ s/\.c$/.rel/;
    push @object_files, "obj\\$rel_file";
    print $fh <<END;
    <CustomBuild Include="$c_source">
      <FileType>CppCode</FileType>
      <Command>..\\..\\..\\bin_vc\\sdcc.exe -mds390 -I..\\..\\include -I. --std-c11 -o obj\\ -c %(FullPath)</Command>
      <Message>Compiling %(FullPath)</Message>
      <Outputs>obj\\%(Filename).rel</Outputs>
    </CustomBuild>
END
}

my $additional_inputs = join(';', @object_files);

print $fh <<END;
    <CustomBuild Include="link_ds390.bat">
      <FileType>Document</FileType>
      <Command>call %(FullPath)</Command>
      <Message>Linking libds390.lib</Message>
      <Outputs>..\\build\\ds390\\libds390.lib</Outputs>
      <AdditionalInputs>$additional_inputs</AdditionalInputs>
    </CustomBuild>
END

my $guid = Data::GUID->new;
$guid = '7383327A-6BF6-1014-A5DE-5CA30E936024'; 
my $namespace = 'ds390lib';

print $fh <<END;
  </ItemGroup>
  <PropertyGroup Label="Globals">
    <VCProjectVersion>16.0</VCProjectVersion>
    <Keyword>Win32Proj</Keyword>
    <ProjectGuid>{$guid}</ProjectGuid>
    <RootNamespace>$namespace</RootNamespace>
    <WindowsTargetPlatformVersion>10.0</WindowsTargetPlatformVersion>
  </PropertyGroup>
END
print $fh <<'END';
  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.Default.props" />
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'" Label="Configuration">
    <ConfigurationType>Utility</ConfigurationType>
    <UseDebugLibraries>true</UseDebugLibraries>
    <PlatformToolset>v142</PlatformToolset>
    <CharacterSet>Unicode</CharacterSet>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|Win32'" Label="Configuration">
    <ConfigurationType>Utility</ConfigurationType>
    <UseDebugLibraries>false</UseDebugLibraries>
    <PlatformToolset>v142</PlatformToolset>
    <WholeProgramOptimization>true</WholeProgramOptimization>
    <CharacterSet>Unicode</CharacterSet>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'" Label="Configuration">
    <ConfigurationType>Utility</ConfigurationType>
    <UseDebugLibraries>true</UseDebugLibraries>
    <PlatformToolset>v142</PlatformToolset>
    <CharacterSet>Unicode</CharacterSet>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'" Label="Configuration">
    <ConfigurationType>Utility</ConfigurationType>
    <UseDebugLibraries>false</UseDebugLibraries>
    <PlatformToolset>v142</PlatformToolset>
    <WholeProgramOptimization>true</WholeProgramOptimization>
    <CharacterSet>Unicode</CharacterSet>
  </PropertyGroup>
  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.props" />
  <ImportGroup Label="ExtensionSettings">
  </ImportGroup>
  <ImportGroup Label="Shared">
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">
    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">
    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
  </ImportGroup>
  <PropertyGroup Label="UserMacros" />
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">
    <LinkIncremental>true</LinkIncremental>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">
    <LinkIncremental>false</LinkIncremental>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
    <LinkIncremental>true</LinkIncremental>
  </PropertyGroup>
  <PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
    <LinkIncremental>false</LinkIncremental>
  </PropertyGroup>
  <ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">
    <ClCompile>
      <WarningLevel>Level3</WarningLevel>
      <SDLCheck>true</SDLCheck>
      <PreprocessorDefinitions>WIN32;_DEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <ConformanceMode>true</ConformanceMode>
    </ClCompile>
    <Link>
      <SubSystem>Console</SubSystem>
      <GenerateDebugInformation>true</GenerateDebugInformation>
    </Link>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">
    <ClCompile>
      <WarningLevel>Level3</WarningLevel>
      <FunctionLevelLinking>true</FunctionLevelLinking>
      <IntrinsicFunctions>true</IntrinsicFunctions>
      <SDLCheck>true</SDLCheck>
      <PreprocessorDefinitions>WIN32;NDEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <ConformanceMode>true</ConformanceMode>
    </ClCompile>
    <Link>
      <SubSystem>Console</SubSystem>
      <EnableCOMDATFolding>true</EnableCOMDATFolding>
      <OptimizeReferences>true</OptimizeReferences>
      <GenerateDebugInformation>true</GenerateDebugInformation>
    </Link>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
    <ClCompile>
      <WarningLevel>Level3</WarningLevel>
      <SDLCheck>true</SDLCheck>
      <PreprocessorDefinitions>_DEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <ConformanceMode>true</ConformanceMode>
    </ClCompile>
    <Link>
      <SubSystem>Console</SubSystem>
      <GenerateDebugInformation>true</GenerateDebugInformation>
    </Link>
  </ItemDefinitionGroup>
  <ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
    <ClCompile>
      <WarningLevel>Level3</WarningLevel>
      <FunctionLevelLinking>true</FunctionLevelLinking>
      <IntrinsicFunctions>true</IntrinsicFunctions>
      <SDLCheck>true</SDLCheck>
      <PreprocessorDefinitions>NDEBUG;_CONSOLE;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      <ConformanceMode>true</ConformanceMode>
    </ClCompile>
    <Link>
      <SubSystem>Console</SubSystem>
      <EnableCOMDATFolding>true</EnableCOMDATFolding>
      <OptimizeReferences>true</OptimizeReferences>
      <GenerateDebugInformation>true</GenerateDebugInformation>
    </Link>
  </ItemDefinitionGroup>
  <ItemGroup>
  </ItemGroup>
  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.targets" />
  <ImportGroup Label="ExtensionTargets">
  </ImportGroup>
</Project>
END

close $fh or die $!;

my $object_files_with_spaces = join(' ', @object_files);

open($fh, '>', "link_ds390.bat") or die $!;

print $fh <<END;
mkdir ..\\build\\ds390
del ..\\build\\ds390\\libds390.lib
..\\..\\..\\bin_vc\\sdar.exe -rcD ..\\build\\ds390\\libds390.lib $object_files_with_spaces
END

close $fh or die $!;

=aaa

    <CustomBuild Include="ds390\tinibios.c">
      <FileType>CppCode</FileType>
      <Command Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">..\..\bin_vc\sdcc.exe -c -mds390 -I..\include -I..\include\mcs51 --nostdinc --std-c11 -o ds390\obj\ %(FullPath)</Command>
      <Message Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">Compiling %(FullPath)</Message>
      <Outputs Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">ds390\obj\%(Filename).rel</Outputs>
      <Command Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">..\..\bin_vc\sdcc.exe -c -mds390 -I..\include -I..\include\mcs51 --nostdinc --std-c11 -o ds390\obj\ %(FullPath)</Command>
      <Message Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">Compiling %(FullPath)</Message>
      <Outputs Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">ds390\obj\%(Filename).rel</Outputs>
      <Command Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">..\..\bin_vc\sdcc.exe -c -mds390 -I..\include -I..\include\mcs51 --nostdinc --std-c11 -o ds390\obj\ %(FullPath)</Command>
      <Message Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">Compiling %(FullPath)</Message>
      <Outputs Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">ds390\obj\%(Filename).rel</Outputs>
      <Command Condition="'$(Configuration)|$(Platform)'=='Release|x64'">..\..\bin_vc\sdcc.exe -c -mds390 -I..\include -I..\include\mcs51 --nostdinc --std-c11 -o ds390\obj\ %(FullPath)</Command>
      <Message Condition="'$(Configuration)|$(Platform)'=='Release|x64'">Compiling %(FullPath)</Message>
      <Outputs Condition="'$(Configuration)|$(Platform)'=='Release|x64'">ds390\obj\%(Filename).rel</Outputs>
    </CustomBuild>
  </ItemGroup>
  <ItemGroup>
    <CustomBuild Include="mcs51\atomic_flag_clear.asm">
      <FileType>Document</FileType>
      <Command>..\..\bin_vc\sdas8051.exe -plosgff %(FullPath)</Command>
      <Message>Compiling %(FullPath)</Message>
      <Outputs>mcs51\%(Filename).rel</Outputs>
    </CustomBuild>
=cut
