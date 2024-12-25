#!/run/current-system/sw/bin/bash
#set -x

# Function to check if a module is loaded
is_module_loaded() {
  lsmod | grep -w "$1" > /dev/null 2>&1
  return $?
}

# Function to check if a module is available
is_module_available() {
  modinfo "$1" > /dev/null 2>&1
  return $?
}

# Function to load a module
load_module() {
  if is_module_available "$1"; then
    modprobe "$1"
    if [ $? -eq 0 ]; then
      echo "Module $1 loaded successfully."
    else
      echo "Failed to load module $1."
    fi
  else
    echo "Module $1 is not available."
  fi
}

# Function to unload a module
unload_module() {
  if is_module_loaded "$1"; then
    rmmod "$1"
    if [ $? -eq 0 ]; then
      echo "Module $1 unloaded successfully."
    else
      echo "Failed to unload module $1."
    fi
  else
    echo "Module $1 is not loaded."
  fi
}

# Function to attach/detach VFIO devices
attach_vfio_devices() {
  if virsh nodedev-reattach pci_0000_01_00_0; then
    echo "GPU device 0 attached successfully."
  else
    echo "Failed to attach GPU device 0."
  fi
  if virsh nodedev-reattach pci_0000_01_00_1; then
    echo "Audio device 1 attached successfully."
  else
    echo "Failed to attach Audio device 1."
  fi
}

detach_vfio_devices() {
  if virsh nodedev-detach pci_0000_01_00_0; then
    echo "GPU device 0 detached successfully."
  else
    echo "Failed to detach GPU device 0."
  fi
  if virsh nodedev-detach pci_0000_01_00_1; then
    echo "Audio device 1 detached successfully."
  else
    echo "Failed to detach Audio device 1."
  fi
}

# Function to check if a device is attached
is_device_attached() {
    virsh nodedev-list | grep "$1" > /dev/null 2>&1 
    return $?
}

# Define module arrays
vfio_modules=("vfio_pci" "vfio_pci_core" "vfio_iommu_type1" "vfio")
nvidia_modules=("nvidia_drm" "nvidia_uvm" "nvidia_modeset" "nvidia")

# Check if a mode argument is provided
if [ "$#" -eq 0 ]; then
    echo "Usage:$) <mode>"
    echo "Modes:"
    echo " 0: Check current mode"
    echo " 1: Desktop (VFIO and NVIDIA unloaded)"
    echo " 2: Work (VFIO loaded and NVIDIA unloaded)"
    echo " 3: Gaming (VFIO unloaded and NVIDIA loaded)"
    exit 1
    #read -p "Enter your choice (0/1/2/3): " mode
fi

mode="$1"

case "$mode" in
    0)
        # Check current mode
        if is_module_loaded "vfio" && is_detached pci_0000_01_00_0 && is_detached pci_0000_01_00_1; then
            echo "Current mode: Work (VFIO and devices detached)"
        elif is_module_loaded "nvidia_drm" || is_module_loaded "nvidia_modeset" || is_module_loaded "nvidia" && ! is_module_loaded "vfio" ; then
            echo "Current mode: Gaming (VFIO off and NVIDIA loaded)"
        else
            echo "Current mode: Desktop (VFIO and NVIDIA modules no loaded)"
        fi
        ;;
    1)
        # Desktop mode
        if is_module_loaded "vfio"; then
            # detach_vfio_devices
            attach_vfio_devices
            for module in "${vfio_modules[@]}"; do
                unload_module "$module"
            done
            echo "VFIO devices detached and modules unloaded."
        fi
        if is_module_loaded "nvidia_drm" || is_module_loaded "nvidia_modeset" || is_module_loaded "nvidia"; then
            for module in "${nvidia_modules[@]}"; do
                unload_module "$module"
            done
            echo "NVIDIA modules unloaded."
        fi
        ;;
    2)
        # Work mode
        # Ensure NVIDIA modules are unloaded first
        for module in "${nvidia_modules[@]}"; do
            unload_module "$module"
        done
        echo "NVIDIA modules unloaded."

        if ! is_module_loaded "vfio"; then
            detach_vfio_devices
            modprobe vfio_pci_core
            echo "Devices detached and VFIO modules loaded."
        fi
	echo "Ready for Work."
        ;;
    3)
        # Gaming mode
        if is_module_loaded "vfio"; then
            # detach_vfio_devicesmod
            attach_vfio_devices
            for module in "${vfio_modules[@]}"; do
                unload_module "$module"
            done
            echo "Devices attached and VFIO modules unloaded."
        fi
        if ! is_module_loaded "nvidia_drm" || ! is_module_loaded "nvidia_modeset"; then
            for module in "${nvidia_modules[@]}"; do
                load_module "$module"
            done
            echo "NVIDIA modules loaded."
	fi
	echo "Ready to Game."
        ;;
    *)
        echo "Invalid choice. Please select 0, 1, 2, or 3."
        ;;
esac
