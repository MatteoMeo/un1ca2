#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# UN1CA configuration file
ROM_VERSION="2.5.5"
ROM_VERSION+="-$(git rev-parse --short HEAD)"
ROM_CODENAME="Eureka"

# Source ROM firmware
case "$TARGET_SINGLE_SYSTEM_IMAGE" in
    # Exynos
    "essi")
        # Galaxy S24+ (One UI 7)
        SOURCE_FIRMWARE="SM-S926/EUX/352737401234563"
        SOURCE_EXTRA_FIRMWARES=()
        SOURCE_API_LEVEL=35
        SOURCE_PRODUCT_FIRST_API_LEVEL=34
	# S25 does not have VNDK as it got deprecated, but keep this in order to keep VNDK patch working
        SOURCE_VNDK_VERSION=34
        SOURCE_HAS_SYSTEM_EXT=true
        # SEC Product Feature
        SOURCE_AUDIO_SUPPORT_ACH_RINGTONE=true
        SOURCE_AUDIO_SUPPORT_DUAL_SPEAKER=true
        SOURCE_AUDIO_SUPPORT_VIRTUAL_VIBRATION=true
        SOURCE_AUTO_BRIGHTNESS_TYPE="5"
        SOURCE_DVFS_CONFIG_NAME="dvfs_policy_default"
        SOURCE_ESE_CHIP_VENDOR="NXP"
        SOURCE_ESE_COS_NAME="JCOP7.0U"
        SOURCE_FP_SENSOR_CONFIG="google_touch_display_ultrasonic"
        SOURCE_HAS_HW_MDNIE=true
        SOURCE_HAS_MASS_CAMERA_APP=false
        SOURCE_HAS_QHD_DISPLAY=true
        SOURCE_HFR_MODE="3"
        SOURCE_HFR_SUPPORTED_REFRESH_RATE="24,10,30,48,60,80,120"
        SOURCE_HFR_DEFAULT_REFRESH_RATE="120"
        SOURCE_DISPLAY_CUTOUT_TYPE="center"
        SOURCE_HFR_SEAMLESS_BRT="84,91"
        SOURCE_HFR_SEAMLESS_LUX="200,2500"
        SOURCE_IS_ESIM_SUPPORTED=true
        SOURCE_MDNIE_SUPPORT_HDR_EFFECT=true
        SOURCE_MDNIE_SUPPORTED_MODES="65303"
        SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION="3"
        SOURCE_MULTI_MIC_MANAGER_VERSION="08020"
        SOURCE_SSRM_CONFIG_NAME="siop_e2s_s5e9945"
        SOURCE_SUPPORT_CUTOUT_PROTECTION=false
        ;;
    *)
        echo "\"$TARGET_SINGLE_SYSTEM_IMAGE\" is not a valid system image."
        return 1
        ;;
esac

return 0
