﻿
///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыполнятьЭкспортДанных = ПолучитьИспользованиеРегламентногоЗадания();
	КаталогЭкспорта = ПолучитьКаталогЭкспорта();

КонецПроцедуры

	
&НаКлиенте
Процедура КаталогФайловЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбранныйКаталог = "";
	РезультатВызова = ОценкаПроизводительностиКлиент.ВызватьДиалогРаботыСФайлами(
		РежимДиалогаВыбораФайла.ВыборКаталога, 
		ВыбранныйКаталог);
	
	Если Не РезультатВызова Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйКаталог <> Неопределено Тогда
		КаталогЭкспорта = ВыбранныйКаталог;
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработкаПроверкиЗаполненияНаСервере()
//Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ВыполнятьЭкспортДанных И ПустаяСтрока(СокрЛП(КаталогЭкспорта)) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Поле = "КаталогЭкспорта";
		Сообщение.Текст = НСтр("ru = 'Поле не заполнено.'");
		Сообщение.Сообщить();
		Возврат Ложь; //Отказ = Истина;
	КонецЕсли;
	
	Возврат Истина;	
КонецФункции

&НаСервере
Процедура СохранитьНаСервере()
//Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьКаталогЭкспорта(КаталогЭкспорта);
	Если ВыполнятьЭкспортДанных Тогда
		УстановитьИспользованиеРегламентногоЗадания(Истина);
	Иначе
		УстановитьИспользованиеРегламентногоЗадания(Ложь);
	КонецЕсли;
		
КонецПроцедуры


///////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура НастроитьРасписаниеЭкспорта(Команда)
	
	РасписаниеРегламентногоЗадания = ПолучитьРасписание();
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	Если Не Диалог.ОткрытьМодально() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьРасписание(Диалог.Расписание);
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// РАБОТА С РЕГЛАМЕНТНЫМ ЗАДАНИЕМ

&НаСервереБезКонтекста
Функция ПолучитьКаталогЭкспорта()
	
	Задание = ПолучитьРегламентноеЗадание();
	Каталог = "";
	Если Задание.Параметры.Количество() > 0 Тогда
		Каталог = Задание.Параметры[0];
	КонецЕсли;
	
	Возврат Каталог;
	
КонецФункции

// Изменяет каталог экспорта данных
//
// Параметры:
//  КаталогЭкспорта - Строка, новый каталог экспорта
//
&НаСервереБезКонтекста
Процедура УстановитьКаталогЭкспорта(КаталогЭкспорта)
	
	Задание = ПолучитьРегламентноеЗадание();
	Если Задание.Параметры.Количество() = 0 Или ВРег(Задание.Параметры[0]) <> ВРег(КаталогЭкспорта) Тогда
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(КаталогЭкспорта);
		Задание.Параметры = ПараметрыЗадания;
		ЗафиксироватьРегламентноеЗадание(Задание);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак использования регламентного задания
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, регламентное задание выполняется
//  	Ложь, регламентное задание не выполняется
//
&НаСервереБезКонтекста
Функция ПолучитьИспользованиеРегламентногоЗадания()
	
	Задание = ПолучитьРегламентноеЗадание();
	Возврат Задание.Использование;
	
КонецФункции

// Изменяет признак использования регламентного задания
//
// Параметры:
//  НовоеЗначение - Булево, новое значение использования
//
// Возвращаемое значение:
//  Булево - состояние до изменения (предыдущее состояние)
//
&НаСервереБезКонтекста
Функция УстановитьИспользованиеРегламентногоЗадания(НовоеЗначение)
	
	Задание = ПолучитьРегламентноеЗадание();
	ТекущееСостояние = Задание.Использование;
	Если ТекущееСостояние <> НовоеЗначение Тогда
		Задание.Использование = НовоеЗначение;
		ЗафиксироватьРегламентноеЗадание(Задание);
	КонецЕсли;
	
	Возврат ТекущееСостояние;
	
КонецФункции

// Возвращает текущее расписание регламентного задания
//
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания - текущее расписание
//
&НаСервереБезКонтекста
Функция ПолучитьРасписание()
	
	Задание = ПолучитьРегламентноеЗадание();
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает новое расписание регламентному заданию
//
// Параметры:
//  НовоеРасписание - РасписаниеРегламентногоЗадания, которе надо установить
//
&НаСервереБезКонтекста
Процедура УстановитьРасписание(Знач НовоеРасписание)
	
	Задание = ПолучитьРегламентноеЗадание();
	Задание.Расписание = НовоеРасписание;
	ЗафиксироватьРегламентноеЗадание(Задание);
	
КонецПроцедуры

// Находит и возвращает предопредленное регламентное задание
//
// Возвращаемое значение:
//  РегламентноеЗадание - РегламентноеЗадание.ЭкспортОценкиПроизводительности, найденное задание
//
&НаСервереБезКонтекста
Функция ПолучитьРегламентноеЗадание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗадания.НайтиПредопределенное(
		Метаданные.РегламентныеЗадания.ЭкспортОценкиПроизводительности);
	
КонецФункции

// Сохраняет настройки регламентного задания
//
// Параметры:
//  Задание - РегламентноеЗадание.ЭкспортОценкиПроизводительности
//
&НаСервереБезКонтекста
Процедура ЗафиксироватьРегламентноеЗадание(Задание)
	
	УстановитьПривилегированныйРежим(Истина);
	Задание.Записать();
	
КонецПроцедуры


&НаКлиенте
Процедура СохранитьНастройки(Команда)
	Если ОбработкаПроверкиЗаполненияНаСервере() Тогда 	
		СохранитьНаСервере();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СохранитьЗакрыть(Команда)
	Если ОбработкаПроверкиЗаполненияНаСервере() Тогда 	
		СохранитьНаСервере();
	    ЭтаФорма.Закрыть();	
	КонецЕсли;
КонецПроцедуры

