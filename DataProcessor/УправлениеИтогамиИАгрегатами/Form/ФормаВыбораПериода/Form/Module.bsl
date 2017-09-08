﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодДляРегНакоп = КонецПериода(ДобавитьМесяц(ТекущаяДатаСеанса(), -1));
	ПериодДляРегБухг = КонецПериода(ТекущаяДатаСеанса());
	
	Элементы.ПериодДляРегБухг.Доступность = Параметры.РегБухгалтерии;
	Элементы.ПериодДляРегНакоп.Доступность = Параметры.РегНакопления;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПериодДляРегНакопПриИзменении(Элемент)
	
	ПериодДляРегНакоп = КонецПериода(ПериодДляРегНакоп);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДляРегБухгПриИзменении(Элемент)
	
	ПериодДляРегБухг = КонецПериода(ПериодДляРегБухг);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура("ПериодДляРегНакоп, ПериодДляРегБухг");
	
	Результат.ПериодДляРегНакоп = ПериодДляРегНакоп;
	Результат.ПериодДляРегБухг = ПериодДляРегБухг;
	
	Закрыть(Результат);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Функция КонецПериода(Дата)
	
	Возврат КонецДня(КонецМесяца(Дата));
	
КонецФункции



