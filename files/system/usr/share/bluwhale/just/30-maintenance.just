# /usr/share/bluwhale/just/30-maintenance.just

[group('Maintenance')]
update-system:
    @echo "--- Starting Global Update via Topgrade ---"
    topgrade
    @echo "--- Cleaning up broken symlinks in home ---"
    find ~ -xtype l -delete
    @echo "--- Checking Xbox Driver Status ---"
    lsmod | grep xone || echo "Warning: xone driver not loaded!"
