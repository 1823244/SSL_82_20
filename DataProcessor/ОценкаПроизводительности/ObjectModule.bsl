﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Функция формирует таблицу значений которая будет выведена пользователю
//
// Возвращаемое значение:
//  ТаблицаЗначений - итоговая таблица значений
//
Функция ПолучитьПоказателиПроизводительности() Экспорт
	
	ПараметрыВычисления = ПолучитьСтруктуруПараметров();
	
	ШагЧисло = 0;
	КоличествоШагов = 0;
	Если Не ПолучитьПериодичность(ШагЧисло, КоличествоШагов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыВычисления.ШагЧисло = ШагЧисло;
	ПараметрыВычисления.КоличествоШагов = КоличествоШагов;
	ПараметрыВычисления.ДатаНачала = ДатаНачала;
	ПараметрыВычисления.ДатаОкончания = ДатаОкончания;
	ПараметрыВычисления.ТЗ = Производительность.Выгрузить(, "КлючеваяОперация, Приоритет, ЦелевоеВремя");
	КОИтого = ОценкаПроизводительностиВызовСервераПолныеПрава.ПолучитьПредопределенный();
	Если КОИтого.Пустая() Или Производительность.Найти(КОИтого, "КлючеваяОперация") = Неопределено Тогда
		ПараметрыВычисления.ВыводитьИтоги = Ложь
	Иначе
		ПараметрыВычисления.ВыводитьИтоги = Истина;
	КонецЕсли;
	
	Возврат ПолучитьAPDEX(ПараметрыВычисления);
	
КонецФункции

// Функция динамически формирует запрос и получает APDEX
//
// Параметры:
//  ПараметрыВычисления - Структура, см. ПолучитьСтруктуруПараметров()
//
// Возвращаемое значение:
//  ТаблицаЗначений - в таблице возвращается ключевая операция и 
//  показатель производительности за определенный период времени
//
Функция ПолучитьAPDEX(ПараметрыВычисления) Экспорт
	
	КОИтого = ОценкаПроизводительностиВызовСервераПолныеПрава.ПолучитьПредопределенный();
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗ", ПараметрыВычисления.ТЗ);
	Запрос.УстановитьПараметр("НачПериода", ПараметрыВычисления.ДатаНачала);
	Запрос.УстановитьПараметр("КонПериода", ПараметрыВычисления.ДатаОкончания);
	Запрос.УстановитьПараметр("КОИтого", КОИтого);
	
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.Приоритет КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя
	|ПОМЕСТИТЬ КлючевыеОперации
	|ИЗ
	|	&ТЗ КАК КлючевыеОперации";
	Запрос.Выполнить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.Приоритет КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя%Колонки%
	|ИЗ
	|	КлючевыеОперации КАК КлючевыеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамерыВремени КАК ЗамерыВремени
	|		ПО КлючевыеОперации.КлючеваяОперация = ЗамерыВремени.КлючеваяОперация
	|		И ЗамерыВремени.ДатаЗамера МЕЖДУ &НачПериода И &КонПериода
	|ГДЕ
	|	НЕ КлючевыеОперации.КлючеваяОперация = &КОИтого
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючевыеОперации.КлючеваяОперация,
	|	КлючевыеОперации.Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя
	|%Итоги%";
	

	Выражение = 
	"
	|	,ВЫБОР
	|		КОГДА СУММА(ВЫБОР
	|					КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|							И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|						ТОГДА 1
	|					ИНАЧЕ 0
	|				КОНЕЦ) = 0
	|			ТОГДА 0
	|		ИНАЧЕ (ВЫРАЗИТЬ((СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) + СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|													И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) / 2) / СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|									ТОГДА 1
	|								ИНАЧЕ 0
	|							КОНЕЦ) + 0.001 КАК ЧИСЛО(6, 3)))
	|	КОНЕЦ КАК Производительность%Номер%";
	
	ВыражениеДляИтогов = 
	"
	|	,СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремВсего%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремДоТ%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|								И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремМеждуТ4Т%Номер%";
	
	Итог = 
	"
	|	МАКСИМУМ(ВремВсего%Номер%)";
	
	ПоОбщие = 
	"
	|ПО
	|	ОБЩИЕ";
	
	ЗаголовкиКолонок = Новый Массив;
	Колонки = "";
	Итоги = "";
	НачПериода = ПараметрыВычисления.ДатаНачала;
	Для а = 0 По ПараметрыВычисления.КоличествоШагов - 1 Цикл
		
		КонПериода = ?(а = ПараметрыВычисления.КоличествоШагов - 1, ПараметрыВычисления.ДатаОкончания, НачПериода + ПараметрыВычисления.ШагЧисло - 1);
		
		Запрос.УстановитьПараметр("НачПериода" + а, НачПериода);
		Запрос.УстановитьПараметр("КонПериода" + а, КонПериода);
		
		ЗаголовкиКолонок.Добавить(ПолучитьЗаголовокКолонки(НачПериода));
		
		НачПериода = НачПериода + ПараметрыВычисления.ШагЧисло;
		
		Колонки = Колонки + ?(ПараметрыВычисления.ВыводитьИтоги, ВыражениеДляИтогов, "") + Выражение;
		Колонки = СтрЗаменить(Колонки, "%Номер%", а);
		
		Если ПараметрыВычисления.ВыводитьИтоги Тогда
			Итоги = Итоги + Итог + ?(а = ПараметрыВычисления.КоличествоШагов - 1, "", ",");
			Итоги = СтрЗаменить(Итоги, "%Номер%", а);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Колонки%", Колонки);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Итоги%", ?(ПараметрыВычисления.ВыводитьИтоги, "ИТОГИ" + Итоги, ""));
	ТекстЗапроса = ТекстЗапроса + ?(ПараметрыВычисления.ВыводитьИтоги, ПоОбщие, "");
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Новый ТаблицаЗначений;
	Иначе
		ТЗ = Результат.Выгрузить();
		
		ТЗ.Сортировать("Приоритет");
		Если ПараметрыВычисления.ВыводитьИтоги Тогда
			ТЗ[0][0] = КОИтого;
			ВычислитьИтоговыйAPDEX(ТЗ);
			ТЗ.Сдвинуть(0, ТЗ.Количество() - 1);
		КонецЕсли;
		
		а = 0;
		ИндексМассива = 0;
		Пока а <= ТЗ.Колонки.Количество() - 1 Цикл
			
			КолонкаТЗ = ТЗ.Колонки[а];
			Если Лев(КолонкаТЗ.Имя, 4) = "Врем" Тогда
				ТЗ.Колонки.Удалить(КолонкаТЗ);
				Продолжить;
			КонецЕсли;
			
			Если а < 3 Тогда
				а = а + 1;
				Продолжить;
			КонецЕсли;
			КолонкаТЗ.Заголовок = ЗаголовкиКолонок[ИндексМассива];
			
			ИндексМассива = ИндексМассива + 1;
			а = а + 1;
			
		КонецЦикла;
		
		Возврат ТЗ;
	КонецЕсли;
	
КонецФункции

// Вычисляет размер и количество шагов на заднном интервале
//
// Параметры:
//  ШагЧисло [OUT] - Число, количество секунд, которое надо прибавить к дате начала чтобы выполнить следующий шаг
//  КоличествоШагов [OUT] - Число, количество шагов на заданном интервале
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, параметры рассчитаны
//  	Ложь, параметры не рассчитаны
//
Функция ПолучитьПериодичность(ШагЧисло, КоличествоШагов) Экспорт
	
	РазницаВремени = ДатаОкончания - ДатаНачала + 1;
	
	Если РазницаВремени <= 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//КоличествоШагов - целое число, округленное вверх
	КоличествоШагов = 0;
	Если Шаг = "Час" Тогда
		ШагЧисло = 86400 / 24;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "День" Тогда
		ШагЧисло = 86400;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Неделя" Тогда
		ШагЧисло = 86400 * 7;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Месяц" Тогда
		ШагЧисло = 86400 * 30;
		Врем = КонецДня(ДатаНачала);
		Пока Врем < ДатаОкончания Цикл
			Врем = ДобавитьМесяц(Врем, 1);
			КоличествоШагов = КоличествоШагов + 1;
		КонецЦикла;
	Иначе
		ШагЧисло = 0;
		КоличествоШагов = 1;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура рассчитывает итоговое значение APDEX
//
// Параметры:
//  ТЗ - ТаблицаЗначений, результат запроса рассчитавшего APDEX
//
Процедура ВычислитьИтоговыйAPDEX(ТЗ)
	
	// Начинаем с 4 колонки первые 3 это КлючеваяОперация, Приоритет, ЦелевоеВремя
	ИндексНачальнойКолонки	= 3;
	ИндексСтрокиИтогов		= 0;
	ИндексКолонкиПриоритет	= 1;
	ИндексПоследнейСтроки	= ТЗ.Количество() - 1;
	ИндексПоследнейКолонки	= ТЗ.Колонки.Количество() - 1;
	МинимальныйПриоритет	= ТЗ[ИндексПоследнейСтроки][ИндексКолонкиПриоритет];
	
	Если МинимальныйПриоритет < 1 Тогда
		Сообщить(НСтр("ru = 'Неверно заолнены приоритеты. Рассчет итогового APDEX невозможен.'"));
		Возврат;
	КонецЕсли;
	
	Колонка = ИндексНачальнойКолонки;
	Пока Колонка < ИндексПоследнейКолонки Цикл
		
		МаксимальноеКоличествоОперацийЗаПериод = ТЗ[ИндексСтрокиИтогов][Колонка];
		//Обнуление строки итогов, чтобы она не повлияла на функцию Итог таблицы значений при расчете итогового APDEX за период
		ТЗ[ИндексСтрокиИтогов][Колонка] = 0;
		// с 1 т.к. 0 это строка итогов
		Для Строка = 1 По ИндексПоследнейСтроки Цикл
			
			ПриоритетТекущейОперации = ТЗ[Строка][ИндексКолонкиПриоритет];
			КоличествоТекущейОперации = ТЗ[Строка][Колонка];
			
			Коэффициент = ?(КоличествоТекущейОперации = 0, 0, 
							МаксимальноеКоличествоОперацийЗаПериод / КоличествоТекущейОперации * (1 - (ПриоритетТекущейОперации - 1) / МинимальныйПриоритет));
			
			ТЗ[Строка][Колонка] = ТЗ[Строка][Колонка] * Коэффициент;
			ТЗ[Строка][Колонка + 1] = ТЗ[Строка][Колонка + 1] * Коэффициент;
			ТЗ[Строка][Колонка + 2] = ТЗ[Строка][Колонка + 2] * Коэффициент;
			
		КонецЦикла;
		
		Н = ТЗ.Итог(ТЗ.Колонки[Колонка].Имя);
		НС = ТЗ.Итог(ТЗ.Колонки[Колонка + 1].Имя);
		НТ = ТЗ.Итог(ТЗ.Колонки[Колонка + 2].Имя);
		Если Н = 0 Тогда
			ИтоговыйAPDEX = 0;
		ИначеЕсли НС = 0 И НТ = 0 И Н <> 0 Тогда
			ИтоговыйAPDEX = 0.001;
		Иначе
			ИтоговыйAPDEX = (НС + НТ / 2) / Н;
		КонецЕсли;
		ТЗ[ИндексСтрокиИтогов][Колонка + 3] = ИтоговыйAPDEX;
		
		Колонка = Колонка + 4;
		
	КонецЦикла;
	
КонецПроцедуры

// Создает структуру параметров необходимую для рассчета APDEX
//
// Возвращаеоме значение:
//  Структура - 
//  	ШагЧисло - Число, указывается размер шага в секундах
//  	КоличествоШагов - Число, количество шагов в периоде
//  	ДатаНачала - Дата, дата начала замеров
//  	ДатаОкнчания - Дата, дата окончания замеров
//  	ТЗ - ТаблицаЗначений,
//  		КлючеваяОперация - СправочникСсылка.КлючевыеОперации, ключевая операция
//  		НомерСтроки - Число, приоритет ключевой операции
//  		ЦелевоеВремя - Число, целевое время ключевой операции
//  	ВыводитьИтоги - Булево,
//  		Истина, вычислять итоговую производительность
//  		Ложь, не вычислять итоговую производительность
//
Функция ПолучитьСтруктуруПараметров() Экспорт
	
	Возврат Новый Структура(
		"ШагЧисло," +
		"КоличествоШагов," + 
		"ДатаНачала," + 
		"ДатаОкончания," + 
		"ТЗ," + 
		"ВыводитьИтоги");
	
КонецФункции

Функция ПолучитьЗаголовокКолонки(НП)
	
	Если Шаг = "Час" Тогда
		// Страна указана для вывода лидирующего нуля чтобы было не 1:30:25, а 01:30:25
		ЗаголовокКолонки = Строка(Формат(НП, "Л=ru_UA; ДЛФ=T"));
	Иначе
		ЗаголовокКолонки = Строка(Формат(НП, "ДФ=dd.MM.yy"));
	КонецЕсли;
	
	Возврат ЗаголовокКолонки;
	
КонецФункции

