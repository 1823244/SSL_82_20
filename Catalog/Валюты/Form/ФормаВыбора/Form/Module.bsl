﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаКурса = НачалоДня(ТекущаяДатаСеанса());
	Элементы.Курс.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Курс на %1'"),
		Формат(ДатаКурса, "ДЛФ=DD")
	);
	Элементы.Курс.Подсказка = Элементы.Курс.Заголовок;
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", ДатаКурса);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
			Элементы.Валюты.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Валюты

&НаКлиенте
Процедура ВалютыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Текст = НСтр("ru = 'Есть возможность подобрать валюту из классификатора.
	|Подобрать?'");
	Результат = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
			ОткрытьФорму(СтандартныеПодсистемыКлиентПереопределяемый.ИмяФормыВыбораКлассификатораВалют(), ПараметрыФормы, Этаформа);
		Иначе
			ОткрытьФорму("Справочник.Валюты.Форма.ФормаПодбораВалютИзОКВ", , ЭтаФорма);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
	ОткрытьФорму(СтандартныеПодсистемыКлиентПереопределяемый.ИмяФормыВыбораКлассификатораВалют(), ПараметрыФормы, Этаформа);
	
КонецПроцедуры

