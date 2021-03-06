﻿&НаКлиенте
Функция ЭтоНавигационнаяСсылка(Ссылка)
	
	Если Найти(Ссылка, "e1cib/data/") <> 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции	

&НаКлиенте
Процедура ОткрытьЗначениеПоиска(Значение)
	СтандартнаяОбработка = Истина;
	ПолнотекстовыйПоискКлиентПереопределяемый.ПриОткрытииОбъекта(Значение, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка = Истина Тогда
		ОткрытьЗначение(Значение);
	КонецЕсли;
КонецПроцедуры

// Возвращает массив объектов (возможно из одного элемента) для показа пользователю
&НаСервереБезКонтекста
Функция ПолучитьЗначенияДляОткрытия(Объект)
	Результат = Новый Массив;
	
	// Объект ссылочного типа
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(Объект) Тогда
		Результат.Добавить(Объект);
		Возврат Результат;
	КонецЕсли;
	
	МетаданныеОбъекта = Объект.Метаданные();
	ИмяМетаданного = МетаданныеОбъекта.Имя;
	
	ПолноеИмяОбъекта = ВРЕГ(МетаданныеОбъекта.ПолноеИмя());
	ЭтоРегистрСведений = (Найти(ПолноеИмяОбъекта, "РЕГИСТРСВЕДЕНИЙ.") > 0);

	Если Не ЭтоРегистрСведений Тогда // Регистр бухгалтерии или накопления или расчета
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;

	// Ниже - это уже регистр сведений
	Если МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;

	// Независимый регистр сведений
	// сперва - основные типы
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
		Если Измерение.Ведущее Тогда 
			ЗначениеИзмерения = Объект[Измерение.Имя];
			
			Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеИзмерения) Тогда
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;

	Если Результат.Количество() = 0 Тогда
		// теперь - любые типы
		Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
			Если Измерение.Ведущее Тогда 
				ЗначениеИзмерения = Объект[Измерение.Имя];
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Нет ни одного ведущего измерения - вернем сам ключ регистра сведений
	Если Результат.Количество() = 0 Тогда
		Результат.Добавить(Объект);
	КонецЕсли;

	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Служебные Функции
//

&НаСервереБезКонтекста
Процедура СохранитьСтрокуПоиска(СписокВыбора, СтрокаПоиска)
	
	СохраненнаяСтрока = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	
	Если СохраненнаяСтрока <> Неопределено Тогда
		СписокВыбора.Удалить(СохраненнаяСтрока);
	КонецЕсли;
		
	СписокВыбора.Вставить(0, СтрокаПоиска);
	
	КоличествоСтрок = СписокВыбора.Количество();
	
	Если КоличествоСтрок > 20 Тогда
		СписокВыбора.Удалить(КоличествоСтрок - 1);
	КонецЕсли;
	
	Строки = СписокВыбора.ВыгрузитьЗначения();
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", 
		, 
		Строки
	);
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьИндексСервер()
	УстановитьПривилегированныйРежим(Истина);
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	
	ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
	ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
	Элементы.ГруппаОбновлениеИндекса.Видимость = Не ИндексАктуален;
	Элементы.ОбновитьИндекс.Доступность = Не ИндексАктуален;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции на которые замэплены обработчики
//

// Процедура поиска, получение и отображение результата
//
&НаКлиенте
Процедура Искать(Направление)
	
	Попытка
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Предупреждение(НСтр("ru = 'Введите, что нужно найти.'"));
			Возврат;
		КонецЕсли;
		
		Если ЭтоНавигационнаяСсылка(СтрокаПоиска) Тогда
			ПерейтиПоНавигационнойСсылке(СтрокаПоиска);
			СтрокаПоиска = "";
			Возврат;
		КонецЕсли;
		
		НСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Выполняется поиск ""%1""...'"), СтрокаПоиска);
		Состояние(НСтрока);
		
		СписокВыбора = Элементы.СтрокаПоиска.СписокВыбора.Скопировать();
		Результат = ВыполнитьПоиск(Направление, ТекущаяПозиция, СтрокаПоиска, СписокВыбора);
		Элементы.СтрокаПоиска.СписокВыбора.Очистить();
		Для Каждого ЭлементСпискаВыбора Из СписокВыбора Цикл
			Элементы.СтрокаПоиска.СписокВыбора.Добавить(ЭлементСпискаВыбора.Значение, ЭлементСпискаВыбора.Представление);
		КонецЦикла;
		
		Если ЭтоФайловаяБаза Тогда
			ОбновитьАктуальностьИндекса();
		КонецЕсли;
		
		Состояние();
		
		РезультатыПоиска = Результат.РезультатПоиска;
		HTMLТекст = Результат.HTMLТекст;
		ТекущаяПозиция = Результат.ТекущаяПозиция;
		ПолноеКоличество = Результат.ПолноеКоличество;
		
		Если РезультатыПоиска.Количество() <> 0 Тогда
			
			ПоказаныРезультатыСПо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			                            НСтр("ru = 'Показаны %1 - %2 из %3'"),
			                            Строка(ТекущаяПозиция + 1),
			                            Строка(ТекущаяПозиция + РезультатыПоиска.Количество()),
			                            Строка(ПолноеКоличество) );
			
			Элементы.Далее.Доступность = (ПолноеКоличество - ТекущаяПозиция) > РезультатыПоиска.Количество();
			Элементы.Назад.Доступность = (ТекущаяПозиция > 0);
		Иначе
			ПоказаныРезультатыСПо = НСтр("ru = 'Не найдено'");
			Элементы.Далее.Доступность = Ложь;
			Элементы.Назад.Доступность = Ложь;
		КонецЕсли;
		
		Если Направление = 0 И Результат.ТекущаяПозиция = 0 И Результат.СлишкомМногоРезультатов Тогда
			Предупреждение(НСтр("ru = 'Слишком много результатов, уточните запрос.'"));
		КонецЕсли;
		
	Исключение
		Предупреждение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки	
			
КонецПроцедуры

&НаСервере
Процедура ОбновитьАктуальностьИндекса()
	
	Если ЭтоФайловаяБаза Тогда
		Элементы.ГруппаОбновлениеИндекса.Видимость = Истина;
		
		Попытка
			ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
			Если ДатаАктуальностиИндекса <> '00010101000000' Тогда
				Элементы.СостояниеИндекса.Подсказка = НСтр("ru = 'Последнее обновление индекса: '") + Строка(ДатаАктуальностиИндекса);
			КонецЕсли;
			
			ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
			Элементы.ГруппаОбновлениеИндекса.Видимость = Не ИндексАктуален;
			Элементы.ОбновитьИндекс.Доступность = Не ИндексАктуален;
			Если Не ИндексАктуален Тогда
				СостояниеИндекса = НСтр("ru = 'Требуется обновление индекса'");
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	Иначе
		Элементы.ГруппаОбновлениеИндекса.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет полнотекстовый поиск
//
&НаСервереБезКонтекста
Функция ВыполнитьПоиск(Направление, ТекущаяПозиция, СтрокаПоиска, СписокВыбора)
	
	СохранитьСтрокуПоиска(СписокВыбора, СтрокаПоиска);
	
	Возврат ИскатьВыполнитьСервер(Направление, ТекущаяПозиция, СтрокаПоиска);
	
КонецФункции

// Процедура выполняет полнотекстовый поиск
//
&НаСервереБезКонтекста
Функция ИскатьВыполнитьСервер(Направление, ТекущаяПозиция, СтрокаПоиска)
	
	РазмерПорции = 20;
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	
	Если Направление = 0 Тогда
		СписокПоиска.ПерваяЧасть();
	ИначеЕсли Направление = -1 Тогда
		СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);
	ИначеЕсли Направление = 1 Тогда
		СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
	КонецЕсли;
	
	РезультатыПоиска = Новый СписокЗначений;
	РезультатыПоиска.Очистить();
	Для Каждого Результат Из СписокПоиска Цикл
		СтруктураРезультата = Новый Структура;
		СтруктураРезультата.Вставить("Значение", Результат.Значение);
		СтруктураРезультата.Вставить("ЗначенияДляОткрытия", ПолучитьЗначенияДляОткрытия(Результат.Значение));
		РезультатыПоиска.Добавить(СтруктураРезультата);
	КонецЦикла;
	
	HTMLТекст = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	
	HTMLТекст = СтрЗаменить(HTMLТекст, "<td>", "<td><font face=""Arial"" size=""2"">");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<td valign=top width=1>", "<td valign=top width=1><font face=""Arial"" size=""1"">");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<body>", "<body topmargin=0 leftmargin=0 scroll=auto>");
	HTMLТекст = СтрЗаменить(HTMLТекст, "</td>", "</font></td>");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<b>", "");
	HTMLТекст = СтрЗаменить(HTMLТекст, "</b>", "");
	
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	СлишкомМногоРезультатов = СписокПоиска.СлишкомМногоРезультатов();
	
	Результат = Новый Структура;
	Результат.Вставить("РезультатПоиска", РезультатыПоиска);
	Результат.Вставить("ТекущаяПозиция", ТекущаяПозиция);
	Результат.Вставить("ПолноеКоличество", ПолноеКоличество);
	Результат.Вставить("HTMLТекст", HTMLТекст);
	Результат.Вставить("СлишкомМногоРезультатов", СлишкомМногоРезультатов);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы и элементов формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединенияСБД);
	ОбновитьАктуальностьИндекса();
	
	Попытка
		ПоказаныРезультатыСПо = НСтр("ru = 'Введите, что нужно найти.'");
		ТекущаяПозиция = 0;
		
		Элементы.Далее.Доступность = Ложь;
		Элементы.Назад.Доступность = Ложь;
		
		Массив = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска");
		
		Если Массив <> Неопределено Тогда
			Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(Массив);
		КонецЕсли;	
		
		Если Не ПустаяСтрока(Параметры.ПереданнаяСтрокаПоиска) Тогда
			СтрокаПоиска = Параметры.ПереданнаяСтрокаПоиска;
			
			СохранитьСтрокуПоиска(Элементы.СтрокаПоиска.СписокВыбора, СтрокаПоиска);
			Результат = ИскатьВыполнитьСервер(0, ТекущаяПозиция, СтрокаПоиска);
			
			РезультатыПоиска = Результат.РезультатПоиска;
			HTMLТекст = Результат.HTMLТекст;
			ТекущаяПозиция = Результат.ТекущаяПозиция;
			ПолноеКоличество = Результат.ПолноеКоличество;
			
			Если РезультатыПоиска.Количество() <> 0 Тогда
				
				ПоказаныРезультатыСПо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                            НСтр("ru = 'Показаны %1 - %2 из %3'"),
				                            Строка(ТекущаяПозиция + 1),
				                            Строка(ТекущаяПозиция + РезультатыПоиска.Количество()),
				                            Строка(ПолноеКоличество) );
				
				Элементы.Далее.Доступность = (ПолноеКоличество - ТекущаяПозиция) > РезультатыПоиска.Количество();
				Элементы.Назад.Доступность = (ТекущаяПозиция > 0);
			Иначе
				ПоказаныРезультатыСПо = НСтр("ru = 'Не найдено'");
				Элементы.Далее.Доступность = Ложь;
				Элементы.Назад.Доступность = Ложь;
			КонецЕсли;
		Иначе
			HTMLТекст = "<html>
						|<head>
						|<meta http-equiv=""Content-Style-Type"" content=""text/css"">
						|</head>
						|<body topmargin=0 leftmargin=0 scroll=auto>
						|<table border=""0"" width=""100%"" cellspacing=""5"">
						|</table>
						|</body>
						|</html>";
		КонецЕсли;	
	Исключение	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	Искать(0);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаПоиска = ВыбранноеЗначение;
	Искать(0);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики команд формы
//

// Обработка команды Найти
//
&НаКлиенте
Процедура ИскатьВыполнить()
	
	Искать(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ДалееВыполнить()
	
	Искать(1);
	
КонецПроцедуры

&НаКлиенте
Процедура НазадВыполнить()
	Искать(-1);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	
	Состояние(НСтр("ru = 'Идет обновление полнотекстового индекса...
					|Пожалуйста, подождите.'"));
	
	ОбновитьИндексСервер();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ЭлементHTML = ДанныеСобытия.Anchor;
	
	Если ЭлементHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ЭлементHTML.id = "FullTextSearchListItem") Тогда
		ЧастьURL = ЭлементHTML.pathName;
		Позиция = СтроковыеФункцииКлиентСервер.НайтиСимволСКонца(ЧастьURL, "/");
		Если Позиция <> 0 Тогда
			ЧастьURL = Сред(ЧастьURL, Позиция + 1);
		КонецЕсли;		
			
		НомерВСписке = Число(ЧастьURL);
		СтруктураРезультата = РезультатыПоиска[НомерВСписке].Значение;
		ВыбраннаяСтрока = СтруктураРезультата.Значение;
		МассивОбъектов = СтруктураРезультата.ЗначенияДляОткрытия;

		Если МассивОбъектов.Количество() = 1 Тогда
			ОткрытьЗначениеПоиска(МассивОбъектов[0]);
		ИначеЕсли МассивОбъектов.Количество() <> 0 Тогда
			Список = Новый СписокЗначений;
			Для Каждого ЭлементМассива Из МассивОбъектов Цикл
				Список.Добавить(ЭлементМассива);
			КонецЦикла;
			ВыбранныйОбъект = ВыбратьИзСписка(Список, Элементы.HTMLТекст);
			Если ВыбранныйОбъект <> Неопределено Тогда
				ОткрытьЗначениеПоиска(ВыбранныйОбъект.Значение);
			КонецЕсли;
		КонецЕсли;

		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

