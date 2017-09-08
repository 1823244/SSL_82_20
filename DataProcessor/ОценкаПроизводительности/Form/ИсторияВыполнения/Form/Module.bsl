﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КлючеваяОперация = Параметры.НастройкиИстории.КлючеваяОперация;
	ДатаНачала = Параметры.НастройкиИстории.ДатаНачала;
	ДатаОкончания = Параметры.НастройкиИстории.ДатаОкончания;
	Приоритет = КлючеваяОперация.Приоритет;
	ЦелевоеВремя = КлючеваяОперация.ЦелевоеВремя;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КлючеваяОперация", КлючеваяОперация);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗамерыВремени.ИмяПользователя КАК Пользователь,
	|	ЗамерыВремени.ВремяВыполнения КАК Длительность,
	|	ЗамерыВремени.ДатаЗамера КАК ВремяОкончания
	|ИЗ
	|	РегистрСведений.ЗамерыВремени КАК ЗамерыВремени
	|ГДЕ
	|	ЗамерыВремени.КлючеваяОперация = &КлючеваяОперация
	|	И ЗамерыВремени.ДатаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяОкончания";
	
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоЗамеровЧисло = Выборка.Количество();
	КоличествоЗамеров = Строка(КоличествоЗамеровЧисло) + ?(КоличествоЗамеровЧисло < 100, " (недостаточно)", "");
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаИстории = История.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаИстории, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Запрещает редактирование ключевой операции из формы обработки
// т.к. могут пострадать внутренние механизмы
//
&НаКлиенте
Процедура КлючеваяОперацияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры
