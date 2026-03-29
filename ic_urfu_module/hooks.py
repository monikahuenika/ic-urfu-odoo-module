# Copyright <2026> Michael <->
# License LGPL-3


def pre_init_hook(cr):
    """Hook executed before module installation.

    None of this module's DB modifications will be available yet.

    :param openerp.sql_db.Cursor cr:
        Database cursor.
    """
    pass


def post_init_hook(cr, registry):
    """Hook executed after module installation.

    This module's DB modifications will be available.

    :param openerp.sql_db.Cursor cr:
        Database cursor.

    :param openerp.modules.registry.RegistryManager registry:
        Database registry, using v8 api.
    """
    pass


def uninstall_hook(cr, registry):
    """Hook executed before module uninstallation.

    This module's DB modifications will still be available.

    :param openerp.sql_db.Cursor cr:
        Database cursor.

    :param openerp.modules.registry.RegistryManager registry:
        Database registry, using v8 api.
    """
    pass


def post_load():
    """Hook executed after module load.

    This is ok as the post-load hook is for server-wide
    (instead of registry-specific) functionalities.
    """
    pass
