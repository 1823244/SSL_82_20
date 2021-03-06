﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Заголовок = ?(ЕстьОписание, НСтр("ru = 'Выберите улицу и населенный пункт'"), НСтр("ru = 'Выберите улицу'"));
	Элементы.НайденныеЗаписиПоИндексу.Шапка = ЕстьОписание;
	Элементы.СкрыватьНеактуальныеАдреса.Пометка = СкрыватьНеактуальныеАдреса;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Индекс = Параметры.Индекс;
	
	НайденоПоИндексу = УправлениеКонтактнойИнформациейКлассификаторы.НайтиЗаписиВАКПоИндексу(Параметры.Индекс);
	Найдено = НайденоПоИндексу.Количество;
	Если Найдено = 0 Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли Найдено > 1 Тогда
		Параметры.НайденныйРегион = НайденоПоИндексу.НайденныйРегион;
		Параметры.НайденныйРайон = НайденоПоИндексу.НайденныйРайон;
		Параметры.ПризнакАктуальности = НайденоПоИндексу.ПризнакАктуальности;
		Параметры.АдресВХранилище = НайденоПоИндексу.АдресВХранилище;
		СкрыватьНеактуальныеАдреса = Параметры.СкрыватьНеактуальныеАдреса;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ВводАдреса", "СкрыватьНеактуальныеАдреса", СкрыватьНеактуальныеАдреса);
	КонецЕсли;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище), "НайденныеЗаписиПоИндексу");
	УдалитьИзВременногоХранилища(Параметры.АдресВХранилище);
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НайденныеЗаписиПоИндексу, ВсеНайденныеЗаписиПоИндексу);
	
	НадписьОРегионеИРайоне = "" + Параметры.Индекс 
	+ ?(ЗначениеЗаполнено(Параметры.НайденныйРегион), ", ", "")	+ Параметры.НайденныйРегион 
	+ ?(ЗначениеЗаполнено(Параметры.НайденныйРегион) И ЗначениеЗаполнено(Параметры.НайденныйРайон), ", ", "") 
	+ Параметры.НайденныйРайон;
	
	ЕстьОписание = Ложь;
	Для Каждого Стр Из НайденныеЗаписиПоИндексу Цикл
		Если Не ПустаяСтрока(Стр.Описание) Тогда
			ЕстьОписание = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.НайденныеЗаписиПоИндексу.ПодчиненныеЭлементы.Описание.Видимость = ЕстьОписание;

	// Восстанавливаем значение флага "Скрывать неактуальные адреса"
	Значение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ВводАдреса", "СкрыватьНеактуальныеАдреса");
	Если Значение = Неопределено Тогда
		СкрыватьНеактуальныеАдреса = Ложь;
	Иначе
		СкрыватьНеактуальныеАдреса = Значение;
	КонецЕсли;
	
	Если СкрыватьНеактуальныеАдреса Тогда
		
		МассивНеактуальныхАдресов = Новый Массив;
		Для Каждого Стр Из НайденныеЗаписиПоИндексу Цикл
			Если Стр.ПризнакАктуальности <> 0 Тогда
				МассивНеактуальныхАдресов.Добавить(Стр);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементМассива Из МассивНеактуальныхАдресов Цикл
			НайденныеЗаписиПоИндексу.Удалить(ЭлементМассива);	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ВводАдреса", "СкрыватьНеактуальныеАдреса", СкрыватьНеактуальныеАдреса);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КомандаВыбратьВыполнить()
	ОбработатьВыбор();
КонецПроцедуры

&НаКлиенте
Процедура НайденныеЗаписиПоИндексуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработатьВыбор();
КонецПроцедуры

&НаКлиенте
Процедура СкрыватьНеактуальныеАдреса(Команда)
	
	СкрыватьНеактуальныеАдреса = Не СкрыватьНеактуальныеАдреса;
	Элементы.СкрыватьНеактуальныеАдреса.Пометка = СкрыватьНеактуальныеАдреса;
	ИзменитьВидимостьНеактуальныхАдресов();
	ЭтаФорма.ОбновитьОтображениеДанных();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработатьВыбор()
	
	Если Элементы.НайденныеЗаписиПоИндексу.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.НайденныеЗаписиПоИндексу.ТекущиеДанные.ПризнакАктуальности <> 0 Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить("Выбрать");
		СписокКнопок.Добавить("Отмена");
		Ответ = Вопрос(НСтр("ru='""" + Элементы.НайденныеЗаписиПоИндексу.ТекущиеДанные.Улица 
		+ ", " + Элементы.НайденныеЗаписиПоИндексу.ТекущиеДанные.Описание + """ не актуален."	
		+ Символы.ПС + "Выбрать его?'"), СписокКнопок);
		Если Ответ = "Отмена" Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	КодАдресногоЭлемента = Элементы.НайденныеЗаписиПоИндексу.ТекущиеДанные.Код;
	Результат = ОбработатьРезультатПоискаПоИндексу(КодАдресногоЭлемента);
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьНеактуальныхАдресов()
	
	Если СкрыватьНеактуальныеАдреса Тогда
		
		МассивНеактуальныхАдресов = Новый Массив;
		Для Каждого Стр Из НайденныеЗаписиПоИндексу Цикл
			Если Стр.ПризнакАктуальности <> 0 Тогда
				МассивНеактуальныхАдресов.Добавить(Стр);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементМассива Из МассивНеактуальныхАдресов Цикл
			НайденныеЗаписиПоИндексу.Удалить(ЭлементМассива);	
		КонецЦикла;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ВсеНайденныеЗаписиПоИндексу, НайденныеЗаписиПоИндексу);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработатьРезультатПоискаПоИндексу(КодАдресногоЭлемента)
	
	// Восстанавливаем значение флага "Скрывать неактуальные адреса"
	Значение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ВводАдреса", "СкрыватьНеактуальныеАдреса");
	Если Значение = Неопределено Тогда
		Результат = Новый Структура("СкрыватьНеактуальныеАдреса", Ложь);
	Иначе
		Результат = Новый Структура("СкрыватьНеактуальныеАдреса", Значение);
	КонецЕсли;
	
	// Заполняем адресные элементы 
	Если КодАдресногоЭлемента = Неопределено Тогда
		Результат.Вставить("ПризнакАктуальности", 0);
		Результат.Вставить("Регион", "");
		Результат.Вставить("Результат", "");
		Результат.Вставить("Город", "");
		Результат.Вставить("НаселенныйПункт", "");
		Результат.Вставить("Улица", "");
	Иначе
		УправлениеКонтактнойИнформациейКлассификаторы.ПоКодуАдресногоЭлементаВСтруктуруПолучитьЕгоКомпоненты(
			КодАдресногоЭлемента, Результат);
		
		ПризнакАктуальности = Результат.ПризнакАктуальности;
		Регион = Результат.Регион;
		Район  = Результат.Район;
		Город  = Результат.Город;
		НаселенныйПункт = Результат.НаселенныйПункт;
		Улица  = Результат.Улица;
		
		СтруктураАдреса = УправлениеКонтактнойИнформациейКлассификаторы.ПолучитьСтруктуруАдресаНаСервере(КодАдресногоЭлемента);
	КонецЕсли;
	
	// Заполняем структуру загруженных по региону
	СтруктураЗагруженных = ЗагруженныеПоляПоРегиону(СтруктураАдреса);
	Результат.Вставить("СтруктураЗагруженных", СтруктураЗагруженных);
	Результат.Вставить("СтруктураАдреса", СтруктураАдреса);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗагруженныеПоляПоРегиону(СтруктураАдреса)
	
	Если УправлениеКонтактнойИнформациейКлассификаторы.АдресныйЭлементЗагружен(СтруктураАдреса.Регион) Тогда
		
		СтруктураЗагруженных = УправлениеКонтактнойИнформациейКлассификаторы.СтруктураЗагруженныхЭлементовАдреса(
		СтруктураАдреса.Регион, СтруктураАдреса.Район, СтруктураАдреса.Город, СтруктураАдреса.НаселенныйПункт, СтруктураАдреса.Улица);
		
		Возврат СтруктураЗагруженных;
		
	Иначе
		
		Возврат Новый Структура("Регион", Ложь);
		
	КонецЕсли;
	
КонецФункции


