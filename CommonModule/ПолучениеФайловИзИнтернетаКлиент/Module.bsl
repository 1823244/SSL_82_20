﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение файлов из интернета"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Общая интерфейсная функция для получения файла из Интернет по протоколу http(s)
// либо ftp и сохранения его во временное хранилище.
//
// Параметры:
// URL*           - строка - url файла в формате:
//                 [Протокол://]<Сервер>/<Путь к файлу на сервере>
// ПараметрыПолучения* - структура с ключами:
//         ПутьДляСохранения  - строка - путь на клиенте (включая имя файла), сохранения
//         Пользователь  - строка - пользователь от имени которого установлено соединение
//         Пароль        - строка - пароль пользователя от которого установлено соединение
//         Порт          - число  - порт сервера с которым установлено соединение
//         ЗащищенноеСоединение - Булево - для случая http загрузки флаг указывает,
//                                  что соединение должно производиться через https
//         ПассивноеСоединение -  - Булево - для случая ftp загрузки флаг указывает,
//                                  что соединение должно пассивным (или активным)
//
// помеченные знаком '*' являются обязательными
//
// Возвращаемое значение:
// структура
// Статус - Булево - ключ присутствует в структуре всегда, значения
//                   Истина - вызов функции успешно завершен
//                   Ложь   - вызов функции завершен неудачно
// Путь - Строка - путь к файлу на клиенте, ключ используется только
//                 если статус Истина
// СообщениеОбОшибке - Строка - сообщение об ошибке, если статус Ложь
//
Функция СкачатьФайлНаКлиенте(знач URL, знач ПараметрыПолучения = Неопределено) Экспорт
	
	// Объявление переменных перед первым использованием в качестве
	// параметра метода Свойство, при анализе параметров получения файлов
	// из ПараметрыПолучения. Содержат значения переданных параметров получения файла
	Перем ПутьДляСохранения, Пользователь, Пароль, Порт, ЗащищенноеСоединение, ПассивноеСоединение;
	
	// Получаем параметры получения файла
	
	Если ПараметрыПолучения = Неопределено Тогда
		ПараметрыПолучения = Новый Структура;
	КонецЕсли;
	
	ПараметрыПолучения.Свойство("ПутьДляСохранения",    ПутьДляСохранения);
	ПараметрыПолучения.Свойство("Пользователь",         Пользователь);
	ПараметрыПолучения.Свойство("Пароль",               Пароль);
	ПараметрыПолучения.Свойство("Порт",                 Порт);
	ПараметрыПолучения.Свойство("ЗащищенноеСоединение", ЗащищенноеСоединение);
	ПараметрыПолучения.Свойство("ПассивноеСоединение",  ПассивноеСоединение);
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Клиент");
	НастройкаСохранения.Вставить("Путь", ПутьДляСохранения);
	
	Результат = ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(
		URL,
		Пользователь,
		Пароль,
		Порт,
		ЗащищенноеСоединение,
		ПассивноеСоединение,
		НастройкаСохранения
	);
	
	Возврат Результат;
	
КонецФункции
