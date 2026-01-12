# /usr/share/bluwhale/Justfile (or your modular maintenance file)

[group('Gaming')]
enroll-secure-boot:
    @echo "Importing Secure Boot key for xone..."
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
    @echo "STEP 2: Reboot now and select 'Enroll MOK' in the blue menu."
    @echo "STEP 3: Use password 'universalblue' when prompted."