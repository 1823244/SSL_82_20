﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Защита персональных данных"
// Модуль предназначен для размещения переопределяемых процедур подсистемы.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура вызывается при заполнении формы "Согласие на обработку персональных данных"
//  данными, переданных в качестве параметров, субъектов
//
// Параметры:
//		СубъектыПерсональныхДанных 	- данные формы коллекция, содержащая сведения о субъектах
//		ДатаАктуальности			- дата, на которую нужно заполнить сведения
//
Процедура ДополнитьДанныеСубъектовПерсональныхДанных(СубъектыПерсональныхДанных, ДатаАктуальности) Экспорт
	
	
	
КонецПроцедуры

// Процедура вызывается при заполнении формы "Согласие на обработку персональных данных"
//  данными организации
//
// Параметры:
//		Организация					- организация - оператор персональных данных
//		ДанныеОрганизации			- структура с данными об организации (адрес, ФИО ответственного и т.д.)
//		ДатаАктуальности			- дата, на которую нужно заполнить сведения
//
Процедура ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Организация, ДанныеОрганизации, ДатаАктуальности) Экспорт
	
	

КонецПроцедуры