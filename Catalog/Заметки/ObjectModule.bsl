﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) и Родитель.Автор <> Автор Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нельзя указывать группу другого пользователя.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда 
		ДатаИзменения = ТекущаяДатаСеанса();
		ПредставлениеПредмета = ОбщегоНазначения.ПредметСтрокой(Предмет);
		
		Позиция = Найти(ТекстСодержания, Символы.ПС);
		Если Позиция > 0 Тогда
			Наименование = Сред(ТекстСодержания, 1, Позиция - 1);
		Иначе
			Наименование = ТекстСодержания;
		КонецЕсли;
		
		Если ПустаяСтрока(Наименование) Тогда 
			Наименование = "<" + НСтр("ru = 'Пустая заметка'") + ">";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

