RENAME TABLE locales_broadcast_text TO broadcast_text_locale;
ALTER TABLE broadcast_text_locale drop FOREIGN KEY broadcast_text_locale_ibfk_1;
ALTER TABLE broadcast_text_locale ENGINE = MyISAM;

RENAME TABLE locales_creature_text TO creature_text_locale;
ALTER TABLE creature_text_locale drop FOREIGN KEY creature_text_locale_ibfk_1;
ALTER TABLE creature_text_locale ENGINE = MyISAM;

ALTER TABLE creature_text drop FOREIGN KEY creature_text_ibfk_2;
ALTER TABLE creature_text ENGINE = MyISAM;