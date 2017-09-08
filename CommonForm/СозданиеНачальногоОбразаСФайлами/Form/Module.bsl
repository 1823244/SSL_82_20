﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Менеджер = ПланыОбмена[Параметры.Узел.Метаданные().Имя];
	
	Если Параметры.Узел = Менеджер.ЭтотУзел() Тогда
		
		ВызватьИсключение НСтр("ru = 'Создание начального образа для данного узла невозможно.'");
		
	Иначе
		
		ВидБазы = 0; // файловая база
		ТипСУБД = "";
		Узел = Параметры.Узел;
		МожноСоздатьФайловуюБазу = Истина;
		СистемнаяИнформация = Новый СистемнаяИнформация;
		Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			МожноСоздатьФайловуюБазу = Ложь;
		КонецЕсли;
		
		КодыЛокализации = ПолучитьДопустимыеКодыЛокализации();
		ЯзыкФайловойБазы = Элементы.Найти("ЯзыкФайловойБазы");
		ЯзыкБазыСервера = Элементы.Найти("ЯзыкБазыСервера");
		
		Для Каждого Код Из КодыЛокализации Цикл
			Представление = ПредставлениеКодаЛокализации(Код);
			ЯзыкФайловойБазы.СписокВыбора.Добавить(Код, Представление);
			ЯзыкБазыСервера.СписокВыбора.Добавить(Код, Представление);
		КонецЦикла;
		
		Язык = КодЛокализацииИнформационнойБазы();
		
	КонецЕсли;
	
	ЕстьФайлыВТомах = Ложь;
	
	Если ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда
		
		КоличествоФайлов = ФайловыеФункции.ПолучитьКоличествоФайловВТомах();
		Если КоличествоФайлов <> 0 Тогда
			ЕстьФайлыВТомах = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьФайлыВТомах Тогда
		ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			Элементы.ПолноеИмяФайловойБазы.АвтоОтметкаНезаполненного = Истина;
			Элементы.ПутьКАрхивуСФайламиТомов.АвтоОтметкаНезаполненного = Истина;
		Иначе
			Элементы.ПолноеИмяФайловойБазыLinux.АвтоОтметкаНезаполненного = Истина;
			Элементы.ПутьКАрхивуСФайламиТомовLinux.АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	Иначе
		Элементы.ГруппаПутьКАрхивуСФайламиТомов.Видимость = Ложь;
	КонецЕсли;
	
	Если СтандартныеПодсистемыВызовСервераПереопределяемый.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
		
		Элементы.ПолноеИмяФайловойБазы.Заголовок = НСтр("ru = 'Для сервера 1С:Предприятия под управлением Microsoft Windows'"); 
		Элементы.ПутьКАрхивуСФайламиТомов.Заголовок = НСтр("ru = 'Для сервера 1С:Предприятия под управлением Microsoft Windows'");
		
	Иначе
		
		Элементы.ПолноеИмяФайловойБазы.КнопкаВыбора = Ложь; 
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидБазыПриИзменении(Элемент)
	
	// переключить страницу параметров
	Страницы = Элементы.Найти("Страницы");
	Страницы.ТекущаяСтраница = Страницы.ПодчиненныеЭлементы[ВидБазы];
	
	Если ЭтаФорма.ВидБазы = 0 Тогда
		Элементы.ПутьКАрхивуСФайламиТомов.Заголовок = НСтр("ru = 'Для сервера 1С:Предприятия под управлением Microsoft Windows'");
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Истина;
	Иначе
		Элементы.ПутьКАрхивуСФайламиТомов.Заголовок = НСтр("ru = 'Для сервера 1С:Предприятия под управлением Microsoft Windows, (вида ""\\имя сервера\resource\files.zip"")'");
		Элементы.ПутьКАрхивуСФайламиТомов.КнопкаВыбора = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачальныйОбраз(Команда)
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Обмен данными'"), ,
						 НСтр("ru = 'Осуществляется создание начального образа...'"),
						 БиблиотекаКартинок.СоздатьНачальныйОбраз);
	
	Если ВидБазы = 0 Тогда
		
		Если НЕ МожноСоздатьФайловуюБазу Тогда
			ВызватьИсключение НСтр("ru = 'Создание начального образа файловой информационной базы на данной платформе не поддерживается.'");
		КонецЕсли;
		
		Если Не ОбменФайламиВызовСервера.СоздатьФайловыйНачальныйОбразНаСервере(Узел, УникальныйИдентификатор, Язык, ПолноеИмяФайловойБазыWindows, ПолноеИмяФайловойБазыLinux, ПутьКАрхивуСФайламиТомовWindows, ПутьКАрхивуСФайламиТомовLinux) Тогда
			Состояние();
			Возврат;
		КонецЕсли;
		
	Иначе
		СтрокаСоединения = "Srvr=""" + Сервер + """;" 
						 + "Ref=""" + ИмяБазы + """;"
						 + "DBMS=""" + ТипСУБД + """;"
						 + "DBSrvr=""" + СерверБазыДанных + """;"
						 + "DB=""" + ИмяБазыДанных + """;"
						 + "DBUID=""" + ПользовательБазыДанных + """;"
						 + "DBPwd=""" + ПарольПользователя + """;"
						 + "SQLYOffs=""" + Формат(СмещениеДат, "ЧГ=") + """;"
						 + "Locale=""" + Язык + """;"
						 + "SchJobDn=""" + ?(УстановитьБлокировкуРегламентныхЗаданий, "Y", "N") + """;";
		
		Если Не ОбменФайламиВызовСервера.СоздатьСерверныйНачальныйОбразНаСервере(Узел, СтрокаСоединения, ПутьКАрхивуСФайламиТомовWindows, ПутьКАрхивуСФайламиТомовLinux) Тогда
			Состояние();
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Предупреждение(НСтр("ru = 'Создание начального образа успешно завершено.'"));
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКАрхивуСФайламиТомовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикСохраненияФайла("ПутьКАрхивуСФайламиТомовWindows", СтандартнаяОбработка, "files.zip", "Архивы zip(*.zip)|*.zip");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяФайловойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработчикСохраненияФайла("ПолноеИмяФайловойБазыWindows", СтандартнаяОбработка, "1Cv8.1CD", "Любой файл(*.*)|*.*");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСохраненияФайла(ИмяСвойства,
									СтандартнаяОбработка,
									ИмяФайла,
									Фильтр = "")
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		Предупреждение(НСтр("ru = 'Для данной операции необходимо установить расширение работы с файлами.'"));
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения'");
	Диалог.ПолноеИмяФайла			= ?(ЭтаФорма[ИмяСвойства] = "", ИмяФайла, ЭтаФорма[ИмяСвойства]);
	Диалог.МножественныйВыбор		= Ложь;
	Диалог.ПредварительныйПросмотр	= Ложь;
	Диалог.Фильтр					= Фильтр;
	
	Если Диалог.Выбрать() Тогда
		
		ЭтаФорма[ИмяСвойства] = Диалог.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры