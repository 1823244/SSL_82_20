﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьЭлементовФормы();
	
	Если ЗначениеЗаполнено(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию) Тогда
		
		ИмяСтраницы = "НастройкиТранспорта[ВидТранспорта]";
		ИмяСтраницы = СтрЗаменить(ИмяСтраницы, "[ВидТранспорта]"
		, ОбщегоНазначения.ИмяЗначенияПеречисления(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию));
		
		Если Элементы[ИмяСтраницы].Видимость Тогда
			
			Элементы.СтраницыВидовТранспорта.ТекущаяСтраница = Элементы[ИмяСтраницы];
			
		КонецЕсли;
		
	КонецЕсли;
	
	СобытиеЖурналаРегистрацииУстановкаПодключенияКWebСервису 
	= ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУстановкаПодключенияКWebСервису();
	
	Элементы.ИсправитьОшибкиУстановкиВнешнегоСоединения.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВариантРаботыИнформационнойБазыПриИзменении();
	
	АутентификацияОперационнойСистемыПриИзменении();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Запись, "COMКаталогИнформационнойБазы", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогИнформационнойБазыОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "COMКаталогИнформационнойБазы", СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаПротоколаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайла(Запись, "ИмяФайлаПротоколаОбмена", СтандартнаяОбработка, НСтр("ru = 'Текстовый документ(*.txt)|*.txt'"), Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаПротоколаОбменаОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "ИмяФайлаПротоколаОбмена", СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура COMВариантРаботыИнформационнойБазыПриИзменении(Элемент)
	
	ВариантРаботыИнформационнойБазыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура COMАутентификацияОперационнойСистемыПриИзменении(Элемент)
	
	АутентификацияОперационнойСистемыПриИзменении();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИсправитьОшибкиУстановкиВнешнегоСоединения(Команда)
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеCOM(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ);
	
	Если Отказ Тогда
		Предупреждение(НСтр("ru = 'Не удалось установить подключение.'"));
	Иначе
		Предупреждение(НСтр("ru = 'Подключение успешно установлено.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеWS(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ВыполнитьПроверкуУстановкиПодключенияWS(Отказ);
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'Ошибка установки подключения.
							|Перейти в журнал регистрации?'"
		);
		Ответ = Вопрос(НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииУстановкаПодключенияКWebСервису);
			ОткрытьФормуМодально("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтаФорма);
			
		КонецЕсли;
		
	Иначе
		Предупреждение(НСтр("ru = 'Подключение успешно установлено.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFILE(Команда)
	
	ПроверитьПодключение("FILE");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFTP(Команда)
	
	ПроверитьПодключение("FTP");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеEMAIL(Команда)
	
	ПроверитьПодключение("EMAIL");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПроверитьПодключение(ВидТранспортаСтрокой)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой);
	
	Если Отказ Тогда
		Предупреждение(НСтр("ru = 'Не удалось установить подключение.'"));
	Иначе
		Предупреждение(НСтр("ru = 'Подключение успешно установлено.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой)
	
	ПроверитьДоступностьФайлаПротоколаОбмена(Отказ);
	
	ОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ, Запись, Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой]);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ)
	
	ПроверитьДоступностьФайлаПротоколаОбмена(Отказ);
	
	ОшибкаПодключенияКомпоненты = Ложь;
	
	ОбменДаннымиСервер.ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ, Запись, ОшибкаПодключенияКомпоненты);
	
	Если ОшибкаПодключенияКомпоненты И ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Элементы.ИсправитьОшибкиУстановкиВнешнегоСоединения.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуУстановкиПодключенияWS(Отказ)
	
	ПроверитьДоступностьФайлаПротоколаОбмена(Отказ);
	
	ПараметрыПодключения = ОбменДаннымиСервер.СтруктураПараметровWS();
	
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения, Запись);
	
	WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения);
	
	Если WSПрокси = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	ИспользуемыеТранспорты = Новый Массив;
	
	Если ЗначениеЗаполнено(Запись.Узел) Тогда
		
		ИспользуемыеТранспорты = ОбменДаннымиПовтИсп.ИспользуемыеТранспортыСообщенийОбмена(Запись.Узел);
		
	КонецЕсли;
	
	Для Каждого СтраницаВидаТранспорта Из Элементы.СтраницыВидовТранспорта.ПодчиненныеЭлементы Цикл
		
		СтраницаВидаТранспорта.Видимость = Ложь;
		
	КонецЦикла;
	
	Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Очистить();
	
	Для Каждого Элемент Из ИспользуемыеТранспорты Цикл
		
		ИмяЭлементаФормы = "НастройкиТранспорта[ВидТранспорта]";
		ИмяЭлементаФормы = СтрЗаменить(ИмяЭлементаФормы, "[ВидТранспорта]", ОбщегоНазначения.ИмяЗначенияПеречисления(Элемент));
		
		Элементы[ИмяЭлементаФормы].Видимость = Истина;
		
		Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Добавить(Элемент, Строка(Элемент));
		
	КонецЦикла;
	
	Если ИспользуемыеТранспорты.Количество() = 1 Тогда
		
		Элементы.СтраницыВидовТранспорта.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаботыИнформационнойБазыПриИзменении()
	
	ТекущаяСтраница = ?(Запись.COMВариантРаботыИнформационнойБазы = 0, Элементы.СтраницаВариантРаботыФайловый, Элементы.СтраницаВариантРаботыКлиентСерверный);
	
	Элементы.ВариантыРаботыИнформационнойБазы.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура АутентификацияОперационнойСистемыПриИзменении()
	
	Элементы.COMИмяПользователя.Доступность    = Не Запись.COMАутентификацияОперационнойСистемы;
	Элементы.COMПарольПользователя.Доступность = Не Запись.COMАутентификацияОперационнойСистемы;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступностьФайлаПротоколаОбмена(Отказ)
	
	СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаПротоколаОбмена);
	ИмяФайлаПротокола = СтруктураИмениФайла.ИмяБезРасширения;
	ИмяКаталогаПроверки	 = СтруктураИмениФайла.Путь;
	КаталогПроверки = Новый Файл(ИмяКаталогаПроверки);
	ИмяФайлаПроверки = "test.tmp";
	
	Если Не ЗначениеЗаполнено(ИмяФайлаПротокола) Тогда
		Возврат;
	ИначеЕсли Не КаталогПроверки.Существует() Тогда
		
		СтрокаСообщения = НСтр("ru = 'Каталог файла протокола обмена ""%1"" не найден.'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки);
		Отказ = Истина;
		
	ИначеЕсли Не СоздатьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки) Тогда
		
		СтрокаСообщения = НСтр("ru = 'Не удалось создать файл в папке протокола обмена: ""%1"".'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки);
		Отказ = Истина;
		
	ИначеЕсли Не УдалитьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки) Тогда
		
		СтрокаСообщения = НСтр("ru = 'Не удалось удалить файл в папке протокола обмена: ""%1"".'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаПроверки);
		Отказ = Истина;
		
	Иначе 
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения,,,, Отказ);
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Транспорт сообщений обмена'"), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщения);
	
КонецПроцедуры

&НаСервере
Функция СоздатьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку(НСтр("ru = 'Временный файл проверки'"));
	
	Попытка
		ТекстовыйДокумент.Записать(ИмяКаталогаПроверки + "/" + ИмяФайлаПроверки);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция УдалитьФайлПроверки(ИмяКаталогаПроверки, ИмяФайлаПроверки)
	
	Попытка
		УдалитьФайлы(ИмяКаталогаПроверки, ИмяФайлаПроверки);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

