import os
import subprocess
from urwid import (Button, Edit, Filler, Frame, ListBox, Pile, Text, 
                   WidgetWrap, MainLoop, SimpleFocusListWalker)

class GentooInstaller:
    def __init__(self):
        self.main_menu = [
            Button("1. Partition Disks", on_press=self.partition_disks),
            Button("2. Configure Make.conf", on_press=self.configure_make_conf),
            Button("3. Install Stage Tarball", on_press=self.install_stage_tarball),
            Button("4. Configure Kernel", on_press=self.configure_kernel),
            Button("5. Install Desktop Environment", on_press=self.install_desktop_environment),
            Button("6. Configure Bootloader", on_press=self.configure_bootloader),
            Button("7. Exit", on_press=self.exit_program)
        ]
        self.main_loop = MainLoop(self.build_interface())

    def build_interface(self):
        menu_list = SimpleFocusListWalker([WidgetWrap(button) for button in self.main_menu])
        list_box = ListBox(menu_list)
        header = Text("Gentoo Installer - TUI")
        footer = Text("Select an option using arrow keys and press Enter.")
        return Frame(Filler(list_box), header=header, footer=footer)

    def partition_disks(self, button):
        self.run_command("parted /dev/sdX", "Partition disks using parted.")

    def configure_make_conf(self, button):
        self.run_command("nano /mnt/gentoo/etc/portage/make.conf", "Edit make.conf for system optimization.")

    def install_stage_tarball(self, button):
        self.run_command("wget https://gentoo.org/stage3.tar.gz && tar xpvf stage3.tar.gz -C /mnt/gentoo",
                         "Download and extract the stage3 tarball.")

    def configure_kernel(self, button):
        self.run_command("genkernel all", "Generate a kernel using genkernel.")

    def install_desktop_environment(self, button):
        self.run_command("emerge --ask kde-plasma/plasma-meta",
                         "Install the KDE Plasma desktop environment.")

    def configure_bootloader(self, button):
        self.run_command("grub-install /dev/sdX && grub-mkconfig -o /boot/grub/grub.cfg",
                         "Install and configure GRUB bootloader.")

    def exit_program(self, button):
        raise SystemExit()

    def run_command(self, command, description):
        subprocess.run(command, shell=True)
        print(f"{description} completed successfully!")

if __name__ == "__main__":
    installer = GentooInstaller()
    installer.main_loop.run()
