import os
import sys

def create_directory_structure():
    directories = [
        "PantryPlanner.xcodeproj",
        "PantryPlanner/Assets.xcassets",
        "PantryPlanner/Assets.xcassets/AppIcon.appiconset",
        "PantryPlanner/Assets.xcassets/AccentColor.colorset"
    ]
    for d in directories:
        os.makedirs(d, exist_ok=True)
        print(f"Created directory: {d}")

def create_assets_files():
    # Assets.xcassets/Contents.json
    with open("PantryPlanner/Assets.xcassets/Contents.json", "w") as f:
        f.write('''{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}''')
    
    # AppIcon.appiconset/Contents.json
    with open("PantryPlanner/Assets.xcassets/AppIcon.appiconset/Contents.json", "w") as f:
        f.write('''{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024",
      "scale" : "1x",
      "filename" : "appicon.png"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}''')

    # AccentColor.colorset/Contents.json
    with open("PantryPlanner/Assets.xcassets/AccentColor.colorset/Contents.json", "w") as f:
        f.write('''{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.000",
          "green" : "0.784",
          "red" : "0.196"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}''')
    print("Created asset contents JSON files.")

def create_project_pbxproj():
    pbxproj_content = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		PBLDFILE_APP /* PantryPlannerApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_APP /* PantryPlannerApp.swift */; };
		PBLDFILE_GC /* GroceryCategory.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_GC /* GroceryCategory.swift */; };
		PBLDFILE_FP /* FamilyProfile.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_FP /* FamilyProfile.swift */; };
		PBLDFILE_ING /* Ingredient.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_ING /* Ingredient.swift */; };
		PBLDFILE_REC /* Recipe.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_REC /* Recipe.swift */; };
		PBLDFILE_WP /* WeeklyPlan.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_WP /* WeeklyPlan.swift */; };
		PBLDFILE_CGI /* CustomGroceryItem.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_CGI /* CustomGroceryItem.swift */; };
		PBLDFILE_ONB /* OnboardingView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_ONB /* OnboardingView.swift */; };
		PBLDFILE_MTV /* MainTabView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_MTV /* MainTabView.swift */; };
		PBLDFILE_RLV /* RecipeListView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_RLV /* RecipeListView.swift */; };
		PBLDFILE_RDV /* RecipeDetailView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_RDV /* RecipeDetailView.swift */; };
		PBLDFILE_AERV /* AddEditRecipeView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_AERV /* AddEditRecipeView.swift */; };
		PBLDFILE_MPV /* MealPlannerView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_MPV /* MealPlannerView.swift */; };
		PBLDFILE_GLV /* GroceryListView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_GLV /* GroceryListView.swift */; };
		PBLDFILE_SV /* SettingsView.swift in Sources */ = {isa = PBXBuildFile; fileRef = FILEREF_SV /* SettingsView.swift */; };
		PBLDFILE_AST /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = FILEREF_AST /* Assets.xcassets */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		FILEREF_APP /* PantryPlannerApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PantryPlannerApp.swift; sourceTree = "<group>"; };
		FILEREF_GC /* GroceryCategory.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GroceryCategory.swift; sourceTree = "<group>"; };
		FILEREF_FP /* FamilyProfile.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FamilyProfile.swift; sourceTree = "<group>"; };
		FILEREF_ING /* Ingredient.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Ingredient.swift; sourceTree = "<group>"; };
		FILEREF_REC /* Recipe.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Recipe.swift; sourceTree = "<group>"; };
		FILEREF_WP /* WeeklyPlan.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = WeeklyPlan.swift; sourceTree = "<group>"; };
		FILEREF_CGI /* CustomGroceryItem.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CustomGroceryItem.swift; sourceTree = "<group>"; };
		FILEREF_ONB /* OnboardingView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = OnboardingView.swift; sourceTree = "<group>"; };
		FILEREF_MTV /* MainTabView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MainTabView.swift; sourceTree = "<group>"; };
		FILEREF_RLV /* RecipeListView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = RecipeListView.swift; sourceTree = "<group>"; };
		FILEREF_RDV /* RecipeDetailView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = RecipeDetailView.swift; sourceTree = "<group>"; };
		FILEREF_AERV /* AddEditRecipeView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AddEditRecipeView.swift; sourceTree = "<group>"; };
		FILEREF_MPV /* MealPlannerView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MealPlannerView.swift; sourceTree = "<group>"; };
		FILEREF_GLV /* GroceryListView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GroceryListView.swift; sourceTree = "<group>"; };
		FILEREF_SV /* SettingsView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SettingsView.swift; sourceTree = "<group>"; };
		FILEREF_AST /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		PBLDPHSF0000000000000001 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		PMAINGRP0000000000000001 = {
			isa = PBXGroup;
			children = (
				PSRCGRP0000000000000001 /* PantryPlanner */,
				PPROJECT0000000000000003 /* Products */,
			);
			sourceTree = "<group>";
		};
		PPROJECT0000000000000003 /* Products */ = {
			isa = PBXGroup;
			children = (
			);
			name = Products;
			sourceTree = "<group>";
		};
		PSRCGRP0000000000000001 /* PantryPlanner */ = {
			isa = PBXGroup;
			children = (
				FILEREF_APP /* PantryPlannerApp.swift */,
				PMODELSG0000000000000001 /* Models */,
				PVIEWSGP0000000000000001 /* Views */,
				FILEREF_AST /* Assets.xcassets */,
			);
			path = PantryPlanner;
			sourceTree = "<group>";
		};
		PMODELSG0000000000000001 /* Models */ = {
			isa = PBXGroup;
			children = (
				FILEREF_GC /* GroceryCategory.swift */,
				FILEREF_FP /* FamilyProfile.swift */,
				FILEREF_ING /* Ingredient.swift */,
				FILEREF_REC /* Recipe.swift */,
				FILEREF_WP /* WeeklyPlan.swift */,
				FILEREF_CGI /* CustomGroceryItem.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		};
		PVIEWSGP0000000000000001 /* Views */ = {
			isa = PBXGroup;
			children = (
				FILEREF_ONB /* OnboardingView.swift */,
				FILEREF_MTV /* MainTabView.swift */,
				FILEREF_RLV /* RecipeListView.swift */,
				FILEREF_RDV /* RecipeDetailView.swift */,
				FILEREF_AERV /* AddEditRecipeView.swift */,
				FILEREF_MPV /* MealPlannerView.swift */,
				FILEREF_GLV /* GroceryListView.swift */,
				FILEREF_SV /* SettingsView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		PTARGET0000000000000001 /* PantryPlanner */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = PCONFIG0000000000000001 /* Build configuration list for PBXNativeTarget "PantryPlanner" */;
			buildPhases = (
				PBLDPHSS0000000000000001 /* Sources */,
				PBLDPHSF0000000000000001 /* Frameworks */,
				PBLDPHSR0000000000000001 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = PantryPlanner;
			productName = PantryPlanner;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		PPROJECT0000000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					PTARGET0000000000000001 = {
						CreatedOnToolsVersion = 15.0;
						DevelopmentTeam = "";
						ProvisioningStyle = Automatic;
					};
				};
			};
			buildConfigurationList = PCONFIG0000000000000002 /* Build configuration list for PBXProject "PantryPlanner" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = PMAINGRP0000000000000001;
			productRefGroup = PPROJECT0000000000000003 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				PTARGET0000000000000001 /* PantryPlanner */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		PBLDPHSR0000000000000001 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				PBLDFILE_AST /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		PBLDPHSS0000000000000001 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				PBLDFILE_APP /* PantryPlannerApp.swift in Sources */,
				PBLDFILE_GC /* GroceryCategory.swift in Sources */,
				PBLDFILE_FP /* FamilyProfile.swift in Sources */,
				PBLDFILE_ING /* Ingredient.swift in Sources */,
				PBLDFILE_REC /* Recipe.swift in Sources */,
				PBLDFILE_WP /* WeeklyPlan.swift in Sources */,
				PBLDFILE_CGI /* CustomGroceryItem.swift in Sources */,
				PBLDFILE_ONB /* OnboardingView.swift in Sources */,
				PBLDFILE_MTV /* MainTabView.swift in Sources */,
				PBLDFILE_RLV /* RecipeListView.swift in Sources */,
				PBLDFILE_RDV /* RecipeDetailView.swift in Sources */,
				PBLDFILE_AERV /* AddEditRecipeView.swift in Sources */,
				PBLDFILE_MPV /* MealPlannerView.swift in Sources */,
				PBLDFILE_GLV /* GroceryListView.swift in Sources */,
				PBLDFILE_SV /* SettingsView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		PCONFIG_BUILD_DEBUG_TARGET = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_CFBundleDisplayName = PantryPlanner;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.household.PantryPlanner;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.9;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		PCONFIG_BUILD_RELEASE_TARGET = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_CFBundleDisplayName = PantryPlanner;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.household.PantryPlanner;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.9;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
		PCONFIG_BUILD_DEBUG_PROJECT = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		PCONFIG_BUILD_RELEASE_PROJECT = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		PCONFIG0000000000000001 /* Build configuration list for PBXNativeTarget "PantryPlanner" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				PCONFIG_BUILD_DEBUG_TARGET,
				PCONFIG_BUILD_RELEASE_TARGET,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		PCONFIG0000000000000002 /* Build configuration list for PBXProject "PantryPlanner" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				PCONFIG_BUILD_DEBUG_PROJECT,
				PCONFIG_BUILD_RELEASE_PROJECT,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = PPROJECT0000000000000001 /* Project object */;
}
"""
    with open("PantryPlanner.xcodeproj/project.pbxproj", "w") as f:
        f.write(pbxproj_content.strip())
    print("Created project.pbxproj file.")

if __name__ == "__main__":
    create_directory_structure()
    create_assets_files()
    create_project_pbxproj()
    print("Xcode project setup successfully!")
