﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДеревоПапок(ДеревоПапок.ПолучитьЭлементы(), ""); // корневые папки
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьДеревоПапок(ВеткаДерева, ИдентификаторПапки)
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	
	ЗапросТип = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/dm", "DMGetSubFoldersRequest");
	Запрос = Прокси.ФабрикаXDTO.Создать(ЗапросТип);
	
	ОбъектТип = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/dm", "DMObjectID");
	Запрос.folder = Прокси.ФабрикаXDTO.Создать(ОбъектТип);
	Запрос.folder.id = ИдентификаторПапки;
	Запрос.folder.type = "DMFileFolder";
	
	Ответ = Прокси.execute(Запрос);
	РаботаС1СДокументооборотВызовСервера.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	ВеткаДерева.Очистить();
	
	Для Каждого ПапкаXDTO Из Ответ.folders Цикл
		Лист = ВеткаДерева.Добавить();
		Лист.УникальныйИдентификатор = ПапкаXDTO.objectId.id;
		Лист.Наименование = ПапкаXDTO.name;
		Лист.ИндексКартинки = 0;
		Лист.ПодпапкиСчитаны = Ложь;
		
		ФиктивныйЛист = Лист.ПолучитьЭлементы().Добавить(); // чтобы появился плюсик
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокФайлов()
	
	СписокФайлов.Очистить();
	
	Файлы = РаботаС1СДокументооборотВызовСервера.ПолучитьСписокФайловПоВладельцу(ИдентификаторТекущейПапки, ИмяТекущейПапки, "DMFileFolder");
	
	Для каждого СведенияОФайле Из Файлы.files Цикл
		НоваяСтрока = СписокФайлов.Добавить();
		
		НоваяСтрока.Файл = СведенияОФайле.name;
		НоваяСтрока.Расширение = СведенияОФайле.extension;
		НоваяСтрока.Описание = СведенияОФайле.description;
		НоваяСтрока.Размер = Формат(СведенияОФайле.size/1024, "ЧЦ=10; ЧН=0");
		НоваяСтрока.ПодписанЭЦП = СведенияОФайле.signed;
		НоваяСтрока.Автор = СведенияОФайле.author.name;
		НоваяСтрока.УникальныйИдентификатор = СведенияОФайле.objectId.id;
		НоваяСтрока.ДатаСоздания = СведенияОФайле.creationDate;
	
		НоваяСтрока.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(НоваяСтрока.Расширение);
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьКарточкуВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	Если Элементы.СписокФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("УникальныйИдентификатор", Элементы.СписокФайлов.ТекущиеДанные.УникальныйИдентификатор);
	ОткрытьФорму("ОбщаяФорма.ДокументооборотКарточкаФайла", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПапокПоИдентификатору(ИдентификаторЭлементаДерева, ИдентификаторПапки)
	
	Лист = ДеревоПапок.НайтиПоИдентификатору(ИдентификаторЭлементаДерева);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьДеревоПапок(Лист.ПолучитьЭлементы(), Лист.УникальныйИдентификатор);
	
КонецПроцедуры		

&НаКлиенте
Процедура ДеревоПапокПередРазворачиванием(Элемент, Строка, Отказ)
	
	Лист = ДеревоПапок.НайтиПоИдентификатору(Строка);
	
	Если Лист = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если НЕ Лист.ПодпапкиСчитаны Тогда
		ЗаполнитьДеревоПапокПоИдентификатору(Строка, Лист.УникальныйИдентификатор);
		Лист.ПодпапкиСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДеревоПапок.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обновляет правый список
&НаКлиенте
Процедура ОбработкаОжидания()
	
	Данные = Элементы.ДеревоПапок.ТекущиеДанные;
	
	Если Данные.УникальныйИдентификатор <> ИдентификаторТекущейПапки Тогда
		ИдентификаторТекущейПапки = Данные.УникальныйИдентификатор;
		ИмяТекущейПапки = Данные.Наименование;
		ОбновитьСписокФайлов();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыбратьВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	Если Элементы.СписокФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ИдентификаторФайла = Элементы.СписокФайлов.ТекущиеДанные.УникальныйИдентификатор;
	Закрыть(ИдентификаторФайла);
	
КонецПроцедуры

