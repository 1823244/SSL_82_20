﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// вызов сервера
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(ПараметрКоманды);
	
	// вызов сервера
	ВидПравил = ПредопределенноеЗначение("Перечисление.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов");
	
	Отбор              = Новый Структура("ИмяПланаОбмена, ВидПравил", ИмяПланаОбмена, ВидПравил);
	ЗначенияЗаполнения = Новый Структура("ИмяПланаОбмена, ВидПравил", ИмяПланаОбмена, ВидПравил);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор, ЗначенияЗаполнения, "ПравилаДляОбменаДанными", ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
