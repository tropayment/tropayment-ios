#!/usr/bin/env python3
"""Generate TropaymentMerchant.xcodeproj/project.pbxproj"""
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent

SOURCES = [
    "TropaymentMerchant/App/TropaymentMerchantApp.swift",
    "TropaymentMerchant/App/RootView.swift",
    "TropaymentMerchant/Core/Configuration/AppConfiguration.swift",
    "TropaymentMerchant/Core/Network/APIClient.swift",
    "TropaymentMerchant/Core/Network/APIError.swift",
    "TropaymentMerchant/Core/Network/APIRequest.swift",
    "TropaymentMerchant/Core/Security/KeychainManager.swift",
    "TropaymentMerchant/Core/Security/BiometricManager.swift",
    "TropaymentMerchant/Core/Session/AppSession.swift",
    "TropaymentMerchant/Models/User.swift",
    "TropaymentMerchant/Models/AuthModels.swift",
    "TropaymentMerchant/Services/AuthService.swift",
    "TropaymentMerchant/Features/Auth/AuthViewModel.swift",
    "TropaymentMerchant/Features/Auth/LoginView.swift",
    "TropaymentMerchant/Features/Auth/TwoFactorView.swift",
    "TropaymentMerchant/Features/Auth/ForgotPasswordView.swift",
    "TropaymentMerchant/Features/Main/MainTabView.swift",
    "TropaymentMerchant/Features/Dashboard/DashboardPlaceholderView.swift",
    "TropaymentMerchant/Features/Payments/PaymentsPlaceholderView.swift",
    "TropaymentMerchant/Features/Transactions/TransactionsPlaceholderView.swift",
    "TropaymentMerchant/Features/Wallet/WalletPlaceholderView.swift",
    "TropaymentMerchant/Features/Settings/SettingsPlaceholderView.swift",
    "TropaymentMerchant/DesignSystem/Colors.swift",
    "TropaymentMerchant/DesignSystem/Typography.swift",
    "TropaymentMerchant/DesignSystem/Spacing.swift",
    "TropaymentMerchant/DesignSystem/Components/PrimaryButton.swift",
    "TropaymentMerchant/DesignSystem/Components/SecondaryButton.swift",
    "TropaymentMerchant/DesignSystem/Components/Card.swift",
    "TropaymentMerchant/DesignSystem/Components/TropaymentTextField.swift",
    "TropaymentMerchant/DesignSystem/Components/LoadingView.swift",
    "TropaymentMerchant/DesignSystem/Components/ErrorView.swift",
    "TropaymentMerchant/DesignSystem/Components/EmptyState.swift",
    "TropaymentMerchant/DesignSystem/Components/StatusBadge.swift",
]

def uid():
    return uuid.uuid4().hex[:24].upper()

ids = {k: uid() for k in [
    'project', 'target', 'sources_phase', 'frameworks_phase', 'resources_phase',
    'project_debug', 'project_release', 'target_debug', 'target_release',
    'project_configs', 'target_configs', 'main_group', 'products_group',
    'app_group', 'product_ref', 'assets_ref', 'assets_build',
    'localizable_ref', 'localizable_build',
    'grp_app', 'grp_core', 'grp_network', 'grp_security', 'grp_config', 'grp_session',
    'grp_models', 'grp_services', 'grp_features', 'grp_auth', 'grp_main',
    'grp_dashboard', 'grp_payments', 'grp_transactions', 'grp_wallet', 'grp_settings',
    'grp_design', 'grp_components', 'grp_resources',
]}

file_ref = {}
build_file = {}
for s in SOURCES:
    name = Path(s).name
    file_ref[s] = uid()
    build_file[s] = uid()

lines = []
lines.append("// !$*UTF8*$!")
lines.append("{")
lines.append("\tarchiveVersion = 1;")
lines.append("\tclasses = {};")
lines.append("\tobjectVersion = 56;")
lines.append("\tobjects = {")
lines.append("")
lines.append("/* Begin PBXBuildFile section */")
for s in SOURCES:
    n = Path(s).name
    lines.append(f"\t\t{build_file[s]} /* {n} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref[s]} /* {n} */; }};")
lines.append(f"\t\t{ids['assets_build']} /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = {ids['assets_ref']} /* Assets.xcassets */; }};")
lines.append(f"\t\t{ids['localizable_build']} /* Localizable.xcstrings in Resources */ = {{isa = PBXBuildFile; fileRef = {ids['localizable_ref']} /* Localizable.xcstrings */; }};")
lines.append("/* End PBXBuildFile section */")
lines.append("")
lines.append("/* Begin PBXFileReference section */")
lines.append(f"\t\t{ids['product_ref']} /* TropaymentMerchant.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = TropaymentMerchant.app; sourceTree = BUILT_PRODUCTS_DIR; }};")
for s in SOURCES:
    n = Path(s).name
    rel = str(Path(s).parent).replace('TropaymentMerchant/', '').replace('TropaymentMerchant\\', '')
    if rel == 'TropaymentMerchant':
        path_attr = f'path = {n};'
    else:
        path_attr = f'path = {n};'
    # store relative path from group
    file_ref_entries_path = n
    lines.append(f"\t\t{file_ref[s]} /* {n} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {n}; sourceTree = \"<group>\"; }};")
lines.append(f"\t\t{ids['assets_ref']} /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = \"<group>\"; }};")
lines.append(f"\t\t{ids['localizable_ref']} /* Localizable.xcstrings */ = {{isa = PBXFileReference; lastKnownFileType = text.json.xcstrings; path = Localizable.xcstrings; sourceTree = \"<group>\"; }};")
lines.append("/* End PBXFileReference section */")
lines.append("")

# Groups mapping
group_files = {
    'grp_app': ['TropaymentMerchant/App/TropaymentMerchantApp.swift', 'TropaymentMerchant/App/RootView.swift'],
    'grp_config': ['TropaymentMerchant/Core/Configuration/AppConfiguration.swift'],
    'grp_network': ['TropaymentMerchant/Core/Network/APIClient.swift', 'TropaymentMerchant/Core/Network/APIError.swift', 'TropaymentMerchant/Core/Network/APIRequest.swift'],
    'grp_security': ['TropaymentMerchant/Core/Security/KeychainManager.swift', 'TropaymentMerchant/Core/Security/BiometricManager.swift'],
    'grp_session': ['TropaymentMerchant/Core/Session/AppSession.swift'],
    'grp_models': ['TropaymentMerchant/Models/User.swift', 'TropaymentMerchant/Models/AuthModels.swift'],
    'grp_services': ['TropaymentMerchant/Services/AuthService.swift'],
    'grp_auth': ['TropaymentMerchant/Features/Auth/AuthViewModel.swift', 'TropaymentMerchant/Features/Auth/LoginView.swift', 'TropaymentMerchant/Features/Auth/TwoFactorView.swift', 'TropaymentMerchant/Features/Auth/ForgotPasswordView.swift'],
    'grp_main': ['TropaymentMerchant/Features/Main/MainTabView.swift'],
    'grp_dashboard': ['TropaymentMerchant/Features/Dashboard/DashboardPlaceholderView.swift'],
    'grp_payments': ['TropaymentMerchant/Features/Payments/PaymentsPlaceholderView.swift'],
    'grp_transactions': ['TropaymentMerchant/Features/Transactions/TransactionsPlaceholderView.swift'],
    'grp_wallet': ['TropaymentMerchant/Features/Wallet/WalletPlaceholderView.swift'],
    'grp_settings': ['TropaymentMerchant/Features/Settings/SettingsPlaceholderView.swift'],
    'grp_components': [
        'TropaymentMerchant/DesignSystem/Components/PrimaryButton.swift',
        'TropaymentMerchant/DesignSystem/Components/SecondaryButton.swift',
        'TropaymentMerchant/DesignSystem/Components/Card.swift',
        'TropaymentMerchant/DesignSystem/Components/TropaymentTextField.swift',
        'TropaymentMerchant/DesignSystem/Components/LoadingView.swift',
        'TropaymentMerchant/DesignSystem/Components/ErrorView.swift',
        'TropaymentMerchant/DesignSystem/Components/EmptyState.swift',
        'TropaymentMerchant/DesignSystem/Components/StatusBadge.swift',
    ],
    'grp_design_files': [
        'TropaymentMerchant/DesignSystem/Colors.swift',
        'TropaymentMerchant/DesignSystem/Typography.swift',
        'TropaymentMerchant/DesignSystem/Spacing.swift',
    ],
}

def group_block(gid, name, children_ids, path=None):
    out = [f"\t\t{gid} /* {name} */ = {{"]
    out.append("\t\t\tisa = PBXGroup;")
    out.append("\t\t\tchildren = (")
    for c in children_ids:
        out.append(f"\t\t\t\t{c},")
    out.append("\t\t\t);")
    if path:
        out.append(f"\t\t\tpath = {path};")
    out.append("\t\t\tsourceTree = \"<group>\";")
    out.append("\t\t};")
    return out

lines.append("/* Begin PBXFrameworksBuildPhase section */")
lines.append(f"\t\t{ids['frameworks_phase']} /* Frameworks */ = {{")
lines.append("\t\t\tisa = PBXFrameworksBuildPhase;")
lines.append("\t\t\tbuildActionMask = 2147483647;")
lines.append("\t\t\tfiles = (")
lines.append("\t\t\t);")
lines.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
lines.append("\t\t};")
lines.append("/* End PBXFrameworksBuildPhase section */")
lines.append("")
lines.append("/* Begin PBXGroup section */")

lines.extend(group_block(ids['main_group'], 'Main', [ids['app_group'], ids['products_group']]))
lines.extend(group_block(ids['products_group'], 'Products', [ids['product_ref']]))
lines.extend(group_block(ids['app_group'], 'TropaymentMerchant', [
    ids['grp_app'], ids['grp_core'], ids['grp_models'], ids['grp_services'], ids['grp_features'], ids['grp_design'], ids['grp_resources']
], path='TropaymentMerchant'))

for g, files in group_files.items():
    if g == 'grp_design_files':
        continue
    name = g.replace('grp_', '').title()
    path = None
    if g == 'grp_app': path = 'App'
    elif g == 'grp_config': path = 'Configuration'
    elif g == 'grp_network': path = 'Network'
    elif g == 'grp_security': path = 'Security'
    elif g == 'grp_session': path = 'Session'
    elif g == 'grp_models': path = 'Models'
    elif g == 'grp_services': path = 'Services'
    elif g == 'grp_auth': path = 'Auth'
    elif g == 'grp_main': path = 'Main'
    elif g == 'grp_dashboard': path = 'Dashboard'
    elif g == 'grp_payments': path = 'Payments'
    elif g == 'grp_transactions': path = 'Transactions'
    elif g == 'grp_wallet': path = 'Wallet'
    elif g == 'grp_settings': path = 'Settings'
    elif g == 'grp_design_files': path = 'DesignSystem'
    elif g == 'grp_components': path = 'Components'
    refs = [f"{file_ref[f]} /* {Path(f).name} */" for f in files]
    lines.extend(group_block(ids[g], name, refs, path))

lines.extend(group_block(ids['grp_core'], 'Core', [ids['grp_network'], ids['grp_security'], ids['grp_config'], ids['grp_session']], path='Core'))
lines.extend(group_block(ids['grp_features'], 'Features', [
    ids['grp_auth'], ids['grp_main'], ids['grp_dashboard'], ids['grp_payments'], ids['grp_transactions'], ids['grp_wallet'], ids['grp_settings']
], path='Features'))

design_children = [ids['grp_components']]
design_files = group_files.get('grp_design_files', [])
if design_files:
    design_children = [f"{file_ref[f]} /* {Path(f).name} */" for f in design_files] + [ids['grp_components']]
lines.extend(group_block(ids['grp_design'], 'DesignSystem', design_children, path='DesignSystem'))
lines.extend(group_block(ids['grp_resources'], 'Resources', [ids['assets_ref'], ids['localizable_ref']], path='Resources'))

lines.append("/* End PBXGroup section */")
lines.append("")
lines.append("/* Begin PBXNativeTarget section */")
lines.append(f"\t\t{ids['target']} /* TropaymentMerchant */ = {{")
lines.append("\t\t\tisa = PBXNativeTarget;")
lines.append(f"\t\t\tbuildConfigurationList = {ids['target_configs']} /* Build configuration list for PBXNativeTarget \"TropaymentMerchant\" */;")
lines.append("\t\t\tbuildPhases = (")
lines.append(f"\t\t\t\t{ids['sources_phase']} /* Sources */,")
lines.append(f"\t\t\t\t{ids['frameworks_phase']} /* Frameworks */,")
lines.append(f"\t\t\t\t{ids['resources_phase']} /* Resources */,")
lines.append("\t\t\t);")
lines.append("\t\t\tbuildRules = (")
lines.append("\t\t\t);")
lines.append("\t\t\tdependencies = (")
lines.append("\t\t\t);")
lines.append("\t\t\tname = TropaymentMerchant;")
lines.append("\t\t\tproductName = TropaymentMerchant;")
lines.append(f"\t\t\tproductReference = {ids['product_ref']} /* TropaymentMerchant.app */;")
lines.append("\t\t\tproductType = \"com.apple.product-type.application\";")
lines.append("\t\t};")
lines.append("/* End PBXNativeTarget section */")
lines.append("")
lines.append("/* Begin PBXProject section */")
lines.append(f"\t\t{ids['project']} /* Project object */ = {{")
lines.append("\t\t\tisa = PBXProject;")
lines.append("\t\t\tattributes = {")
lines.append("\t\t\t\tBuildIndependentTargetsInParallel = 1;")
lines.append("\t\t\t\tLastSwiftUpdateCheck = 1600;")
lines.append("\t\t\t\tLastUpgradeCheck = 1600;")
lines.append("\t\t\t\tTargetAttributes = {")
lines.append(f"\t\t\t\t\t{ids['target']} = {{")
lines.append("\t\t\t\t\t\tCreatedOnToolsVersion = 16.0;")
lines.append("\t\t\t\t\t};")
lines.append("\t\t\t\t};")
lines.append("\t\t\t};")
lines.append(f"\t\t\tbuildConfigurationList = {ids['project_configs']} /* Build configuration list for PBXProject \"TropaymentMerchant\" */;")
lines.append("\t\t\tcompatibilityVersion = \"Xcode 14.0\";")
lines.append("\t\t\tdevelopmentRegion = en;")
lines.append("\t\t\thasScannedForEncodings = 0;")
lines.append("\t\t\tknownRegions = (")
lines.append("\t\t\t\ten,")
lines.append("\t\t\t\tBase,")
lines.append("\t\t\t\tar,")
lines.append("\t\t\t\t\"zh-Hans\",")
lines.append("\t\t\t\tko,")
lines.append("\t\t\t);")
lines.append(f"\t\t\tmainGroup = {ids['main_group']};")
lines.append(f"\t\t\tproductRefGroup = {ids['products_group']} /* Products */;")
lines.append("\t\t\tprojectDirPath = \"\";")
lines.append("\t\t\tprojectRoot = \"\";")
lines.append("\t\t\ttargets = (")
lines.append(f"\t\t\t\t{ids['target']} /* TropaymentMerchant */,")
lines.append("\t\t\t);")
lines.append("\t\t};")
lines.append("/* End PBXProject section */")
lines.append("")
lines.append("/* Begin PBXResourcesBuildPhase section */")
lines.append(f"\t\t{ids['resources_phase']} /* Resources */ = {{")
lines.append("\t\t\tisa = PBXResourcesBuildPhase;")
lines.append("\t\t\tbuildActionMask = 2147483647;")
lines.append("\t\t\tfiles = (")
lines.append(f"\t\t\t\t{ids['assets_build']} /* Assets.xcassets in Resources */,")
lines.append(f"\t\t\t\t{ids['localizable_build']} /* Localizable.xcstrings in Resources */,")
lines.append("\t\t\t);")
lines.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
lines.append("\t\t};")
lines.append("/* End PBXResourcesBuildPhase section */")
lines.append("")
lines.append("/* Begin PBXSourcesBuildPhase section */")
lines.append(f"\t\t{ids['sources_phase']} /* Sources */ = {{")
lines.append("\t\t\tisa = PBXSourcesBuildPhase;")
lines.append("\t\t\tbuildActionMask = 2147483647;")
lines.append("\t\t\tfiles = (")
for s in SOURCES:
    n = Path(s).name
    lines.append(f"\t\t\t\t{build_file[s]} /* {n} in Sources */,")
lines.append("\t\t\t);")
lines.append("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
lines.append("\t\t};")
lines.append("/* End PBXSourcesBuildPhase section */")
lines.append("")

# Build configs
for key, name in [('project_debug', 'Debug'), ('project_release', 'Release')]:
    lines.append(f"\t\t{ids[key]} /* {name} */ = {{")
    lines.append("\t\t\tisa = XCBuildConfiguration;")
    lines.append("\t\t\tbuildSettings = {")
    if name == 'Debug':
        lines.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
        lines.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
        lines.append("\t\t\t\tCOPY_PHASE_STRIP = NO;")
        lines.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;")
        lines.append("\t\t\t\tENABLE_TESTABILITY = YES;")
        lines.append("\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;")
        lines.append("\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;")
        lines.append("\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (\"DEBUG=1\", \"$(inherited)\");")
        lines.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
        lines.append("\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;")
        lines.append("\t\t\t\tONLY_ACTIVE_ARCH = YES;")
        lines.append("\t\t\t\tSDKROOT = iphoneos;")
        lines.append("\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;")
        lines.append("\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-Onone\";")
    else:
        lines.append("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
        lines.append("\t\t\t\tCLANG_ENABLE_MODULES = YES;")
        lines.append("\t\t\t\tCOPY_PHASE_STRIP = NO;")
        lines.append("\t\t\t\tDEBUG_INFORMATION_FORMAT = \"dwarf-with-dsym\";")
        lines.append("\t\t\t\tENABLE_NS_ASSERTIONS = NO;")
        lines.append("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 16.0;")
        lines.append("\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;")
        lines.append("\t\t\t\tSDKROOT = iphoneos;")
        lines.append("\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;")
        lines.append("\t\t\t\tVALIDATE_PRODUCT = YES;")
    lines.append("\t\t\t};")
    lines.append(f"\t\t\tname = {name};")
    lines.append("\t\t};")

target_settings = """
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_CFBundleDisplayName = "tropayment Merchant";
\t\t\t\tINFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.finance";
\t\t\t\tINFOPLIST_KEY_NSFaceIDUsageDescription = "Unlock your merchant session with Face ID.";
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = ("$(inherited)", "@executable_path/Frameworks");
\t\t\t\tMARKETING_VERSION = 1.0.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.tropayment.merchant;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
"""

for key, name in [('target_debug', 'Debug'), ('target_release', 'Release')]:
    lines.append(f"\t\t{ids[key]} /* {name} */ = {{")
    lines.append("\t\t\tisa = XCBuildConfiguration;")
    lines.append("\t\t\tbuildSettings = {")
    lines.append(target_settings)
    lines.append("\t\t\t};")
    lines.append(f"\t\t\tname = {name};")
    lines.append("\t\t};")

lines.append("")
lines.append("/* Begin XCConfigurationList section */")
lines.append(f"\t\t{ids['project_configs']} /* Build configuration list for PBXProject \"TropaymentMerchant\" */ = {{")
lines.append("\t\t\tisa = XCConfigurationList;")
lines.append("\t\t\tbuildConfigurations = (")
lines.append(f"\t\t\t\t{ids['project_debug']} /* Debug */,")
lines.append(f"\t\t\t\t{ids['project_release']} /* Release */,")
lines.append("\t\t\t);")
lines.append("\t\t\tdefaultConfigurationIsVisible = 0;")
lines.append("\t\t\tdefaultConfigurationName = Release;")
lines.append("\t\t};")
lines.append(f"\t\t{ids['target_configs']} /* Build configuration list for PBXNativeTarget \"TropaymentMerchant\" */ = {{")
lines.append("\t\t\tisa = XCConfigurationList;")
lines.append("\t\t\tbuildConfigurations = (")
lines.append(f"\t\t\t\t{ids['target_debug']} /* Debug */,")
lines.append(f"\t\t\t\t{ids['target_release']} /* Release */,")
lines.append("\t\t\t);")
lines.append("\t\t\tdefaultConfigurationIsVisible = 0;")
lines.append("\t\t\tdefaultConfigurationName = Release;")
lines.append("\t\t};")
lines.append("/* End XCConfigurationList section */")
lines.append("\t};")
lines.append(f"\trootObject = {ids['project']} /* Project object */;")
lines.append("}")
lines.append("")

out = ROOT / 'TropaymentMerchant.xcodeproj' / 'project.pbxproj'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text('\n'.join(lines), encoding='utf-8')
print(f'Wrote {out}')
