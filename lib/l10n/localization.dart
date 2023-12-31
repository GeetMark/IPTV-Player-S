import 'dart:io';

import 'package:flutter/material.dart';

class Localization {
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "IPTV_Channels": "IPTV Channels",
      "Providers": "Providers",
      "You_haven_added_IPTV_provider": "You haven't added an IPTV provider yet ",
      "Import_M3U_File": "Import M3U File",
      "Favorite_Channels": "Favorite Channels",
      "Remove": "Remove",
      "Favorite": "Favorite",
      "IPTV_List": "IPTV List",
      "Item_removed_successfully": "Item removed successfully!",
      "Add_New_IPTV": "Add New IPTV",
      "Channels_saved_successfully": "Channels saved successfully!",
      "Loading": "Loading...",
      "Failed_to_fetch_channels": "Failed to fetch channels.",
      "An_error_occurred": "An error occurred",
      "Add_New_IPTV_from_URL": "Add New IPTV from URL",
      "IPTV_from_TEXT": "IPTV from TEXT",
      "IPTV_from_Storage": "IPTV from Storage",
      "You_need_Update_App": "You Need Update App !",
      "Name": "Name",
      "Cancel": "Cancel",
      "Add": "Add",
      "IPTV_Text": "IPTV Text",
      "Remove": "Remove",
      "Username": "Username",
      "Password": "Password",
      "Import_m3u_with_username_and_password": "Import M3U with username and password",
    },
    'fr': {
      "IPTV_Channels": "Chaînes IPTV",
      "Providers": "Fournisseurs",
      "You_haven_added_IPTV_provider": "Vous n'avez pas encore ajouté de fournisseur IPTV",
      "Import_M3U_File": "Importer un fichier M3U",
      "Favorite_Channels": "Chaînes favorites",
      "Remove": "Supprimer",
      "Favorite": "Favori",
      "IPTV_List": "Liste IPTV",
      "Item_removed_successfully": "Élément supprimé avec succès !",
      "Add_New_IPTV": "Ajouter un nouveau IPTV",
      "Channels_saved_successfully": "Chaînes enregistrées avec succès !",
      "Loading": "Chargement en cours...",
      "Failed_to_fetch_channels": "Échec de récupération des chaînes.",
      "An_error_occurred": "Une erreur est survenue",
      "Add_New_IPTV_from_URL": "Ajouter un nouveau IPTV depuis une URL",
      "IPTV_from_TEXT": "IPTV depuis un texte",
      "IPTV_from_Storage": "IPTV depuis le stockage",
      "You_need_Update_App": "Vous avez besoin de mettre à jour l'application !",
      "Name": "Nom",
      "Cancel": "Annuler",
      "Add": "Ajouter",
      "IPTV_Text": "Texte IPTV",
      "Remove": "Supprimer",
    },
    'es': {
      "IPTV_Channels": "Canales de IPTV",
      "Providers": "Proveedores",
      "You_haven_added_IPTV_provider": "Aún no has agregado un proveedor de IPTV",
      "Import_M3U_File": "Importar archivo M3U",
      "Favorite_Channels": "Canales favoritos",
      "Remove": "Eliminar",
      "Favorite": "Favorito",
      "IPTV_List": "Lista de IPTV",
      "Item_removed_successfully": "¡Elemento eliminado con éxito!",
      "Add_New_IPTV": "Agregar nuevo IPTV",
      "Channels_saved_successfully": "¡Canales guardados con éxito!",
      "Loading": "Cargando...",
      "Failed_to_fetch_channels": "Error al recuperar los canales.",
      "An_error_occurred": "Ha ocurrido un error",
      "Add_New_IPTV_from_URL": "Agregar nuevo IPTV desde URL",
      "IPTV_from_TEXT": "IPTV desde TEXTO",
      "IPTV_from_Storage": "IPTV desde almacenamiento",
      "You_need_Update_App": "¡Necesitas actualizar la aplicación!",
      "Name": "Nombre",
      "Cancel": "Cancelar",
      "Add": "Agregar",
      "IPTV_Text": "Texto IPTV",
      "Remove": "Eliminar",
    },
    'de': {
      "IPTV_Channels": "IPTV-Kanäle",
      "Providers": "Anbieter",
      "You_haven_added_IPTV_provider": "Du hast noch keinen IPTV-Anbieter hinzugefügt",
      "Import_M3U_File": "M3U-Datei importieren",
      "Favorite_Channels": "Lieblingskanäle",
      "Remove": "Entfernen",
      "Favorite": "Favorit",
      "IPTV_List": "IPTV-Liste",
      "Item_removed_successfully": "Element erfolgreich entfernt!",
      "Add_New_IPTV": "Neues IPTV hinzufügen",
      "Channels_saved_successfully": "Kanäle erfolgreich gespeichert!",
      "Loading": "Laden...",
      "Failed_to_fetch_channels": "Fehler beim Abrufen der Kanäle.",
      "An_error_occurred": "Ein Fehler ist aufgetreten",
      "Add_New_IPTV_from_URL": "Neues IPTV von URL hinzufügen",
      "IPTV_from_TEXT": "IPTV aus TEXT",
      "IPTV_from_Storage": "IPTV aus Speicher",
      "You_need_Update_App": "Du musst die App aktualisieren!",
      "Name": "Name",
      "Cancel": "Abbrechen",
      "Add": "Hinzufügen",
      "IPTV_Text": "IPTV-Text",
      "Remove": "Entfernen",
    },
    'ar': {
      "IPTV_Channels": "قنوات IPTV",
      "Providers": "مقدمون",
      "You_haven_added_IPTV_provider": "لم تقم بإضافة مزود IPTV بعد",
      "Import_M3U_File": "استيراد ملف M3U",
      "Favorite_Channels": "القنوات المفضلة",
      "Remove": "إزالة",
      "Favorite": "مفضل",
      "IPTV_List": "قائمة IPTV",
      "Item_removed_successfully": "تمت إزالة العنصر بنجاح!",
      "Add_New_IPTV": "إضافة IPTV جديد",
      "Channels_saved_successfully": "تم حفظ القنوات بنجاح!",
      "Loading": "جار التحميل...",
      "Failed_to_fetch_channels": "فشل في جلب القنوات.",
      "An_error_occurred": "حدث خطأ",
      "Add_New_IPTV_from_URL": "إضافة IPTV جديد من رابط",
      "IPTV_from_TEXT": "IPTV من النص",
      "IPTV_from_Storage": "IPTV من التخزين",
      "You_need_Update_App": "تحتاج إلى تحديث التطبيق!",
      "Name": "الاسم",
      "Cancel": "إلغاء",
      "Add": "إضافة",
      "IPTV_Text": "نص IPTV",
      "Remove": "إزالة",
    },
    'hi': {
      "IPTV_Channels": "IPTV चैनल",
      "Providers": "प्रदाता",
      "You_haven_added_IPTV_provider": "आपने अब तक IPTV प्रदाता नहीं जोड़ा है",
      "Import_M3U_File": "M3U फ़ाइल आयात करें",
      "Favorite_Channels": "पसंदीदा चैनल",
      "Remove": "हटाएँ",
      "Favorite": "पसंदीदा",
      "IPTV_List": "IPTV सूची",
      "Item_removed_successfully": "आइटम सफलतापूर्वक हटा दिया गया!",
      "Add_New_IPTV": "नया IPTV जोड़ें",
      "Channels_saved_successfully": "चैनल सफलतापूर्वक सहेजे गए!",
      "Loading": "लोड हो रहा है...",
      "Failed_to_fetch_channels": "चैनल लाने में विफल।",
      "An_error_occurred": "कोई त्रुटि हुई",
      "Add_New_IPTV_from_URL": "URL से नया IPTV जोड़ें",
      "IPTV_from_TEXT": "पाठ से IPTV",
      "IPTV_from_Storage": "स्टोरेज से IPTV",
      "You_need_Update_App": "आपको ऐप को अपडेट करने की आवश्यकता है!",
      "Name": "नाम",
      "Cancel": "रद्द करें",
      "Add": "जोड़ें",
      "IPTV_Text": "IPTV पाठ",
      "Remove": "हटाएँ",
    },
    'zh': {
      "IPTV_Channels": "IPTV频道",
      "Providers": "提供商",
      "You_haven_added_IPTV_provider": "您尚未添加IPTV提供商",
      "Import_M3U_File": "导入M3U文件",
      "Favorite_Channels": "收藏的频道",
      "Remove": "移除",
      "Favorite": "收藏",
      "IPTV_List": "IPTV列表",
      "Item_removed_successfully": "项目已成功移除！",
      "Add_New_IPTV": "添加新的IPTV",
      "Channels_saved_successfully": "频道已成功保存！",
      "Loading": "加载中...",
      "Failed_to_fetch_channels": "获取频道失败。",
      "An_error_occurred": "发生错误",
      "Add_New_IPTV_from_URL": "从URL添加新的IPTV",
      "IPTV_from_TEXT": "从文本添加IPTV",
      "IPTV_from_Storage": "从存储添加IPTV",
      "You_need_Update_App": "您需要更新应用程序！",
      "Name": "名称",
      "Cancel": "取消",
      "Add": "添加",
      "IPTV_Text": "IPTV文本",
      "Remove": "移除",
    },
    'it': {
      "IPTV_Channels": "Canali IPTV",
      "Providers": "Provider",
      "You_haven_added_IPTV_provider": "Non hai ancora aggiunto un provider IPTV",
      "Import_M3U_File": "Importa file M3U",
      "Favorite_Channels": "Canali preferiti",
      "Remove": "Rimuovi",
      "Favorite": "Preferito",
      "IPTV_List": "Lista IPTV",
      "Item_removed_successfully": "Elemento rimosso con successo!",
      "Add_New_IPTV": "Aggiungi nuovo IPTV",
      "Channels_saved_successfully": "Canali salvati con successo!",
      "Loading": "Caricamento...",
      "Failed_to_fetch_channels": "Impossibile recuperare i canali.",
      "An_error_occurred": "Si è verificato un errore",
      "Add_New_IPTV_from_URL": "Aggiungi nuovo IPTV da URL",
      "IPTV_from_TEXT": "IPTV da testo",
      "IPTV_from_Storage": "IPTV da archivio",
      "You_need_Update_App": "Devi aggiornare l'applicazione!",
      "Name": "Nome",
      "Cancel": "Annulla",
      "Add": "Aggiungi",
      "IPTV_Text": "Testo IPTV",
      "Remove": "Rimuovi",
    },
    'pt': {
      "IPTV_Channels": "Canais IPTV",
      "Providers": "Fornecedores",
      "You_haven_added_IPTV_provider": "Você ainda não adicionou um fornecedor de IPTV",
      "Import_M3U_File": "Importar Arquivo M3U",
      "Favorite_Channels": "Canais Favoritos",
      "Remove": "Remover",
      "Favorite": "Favorito",
      "IPTV_List": "Lista IPTV",
      "Item_removed_successfully": "Item removido com sucesso!",
      "Add_New_IPTV": "Adicionar Novo IPTV",
      "Channels_saved_successfully": "Canais salvos com sucesso!",
      "Loading": "Carregando...",
      "Failed_to_fetch_channels": "Falha ao buscar canais.",
      "An_error_occurred": "Ocorreu um erro",
      "Add_New_IPTV_from_URL": "Adicionar Novo IPTV a partir de URL",
      "IPTV_from_TEXT": "IPTV a partir de TEXTO",
      "IPTV_from_Storage": "IPTV a partir de Armazenamento",
      "You_need_Update_App": "Você precisa atualizar o aplicativo!",
      "Name": "Nome",
      "Cancel": "Cancelar",
      "Add": "Adicionar",
      "IPTV_Text": "Texto IPTV",
      "Remove": "Remover",
    },
    'ru': {
      "IPTV_Channels": "IPTV Каналы",
      "Providers": "Провайдеры",
      "You_haven_added_IPTV_provider": "Вы еще не добавили IPTV провайдера",
      "Import_M3U_File": "Импортировать файл M3U",
      "Favorite_Channels": "Избранные каналы",
      "Remove": "Удалить",
      "Favorite": "Избранное",
      "IPTV_List": "Список IPTV",
      "Item_removed_successfully": "Элемент успешно удален!",
      "Add_New_IPTV": "Добавить новый IPTV",
      "Channels_saved_successfully": "Каналы успешно сохранены!",
      "Loading": "Загрузка...",
      "Failed_to_fetch_channels": "Не удалось получить каналы.",
      "An_error_occurred": "Произошла ошибка",
      "Add_New_IPTV_from_URL": "Добавить новый IPTV по URL",
      "IPTV_from_TEXT": "IPTV из текста",
      "IPTV_from_Storage": "IPTV из хранилища",
      "You_need_Update_App": "Вам нужно обновить приложение!",
      "Name": "Имя",
      "Cancel": "Отмена",
      "Add": "Добавить",
      "IPTV_Text": "Текст IPTV",
      "Remove": "Удалить",
    }

  };

  static String _currentLanguageCode = 'en'; // Default language is English

  static void setLanguage(String languageCode) {
    if (_localizedValues.containsKey(languageCode)) {
      _currentLanguageCode = languageCode;
    } else {
      print('Language not supported: $languageCode');
    }
  }
  static void setInitialLanguage() {
    String localeName = Platform.localeName;
    String deviceLanguage = localeName.split('_')[0];
    print('Device Language: $deviceLanguage'); // Debug print
    if (_localizedValues.containsKey(deviceLanguage)) {
      _currentLanguageCode = deviceLanguage;
    } else {
      print('Device language not supported: $deviceLanguage');
    }
  }



  static String get(String key) {
    return _localizedValues[_currentLanguageCode]?.containsKey(key) == true
        ? _localizedValues[_currentLanguageCode]![key]!
        : key;
  }
}
