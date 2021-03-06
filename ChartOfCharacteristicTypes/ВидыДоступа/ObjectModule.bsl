﻿
// Обработчик события ПередЗаписью предотвращает изменение видов доступа,
// которые должны изменятся только в режиме конфигурирования.
//
Процедура ПередЗаписью(Отказ)
	
	Если Предопределенный И ОбменДанными.Загрузка Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "ТипЗначения, Наименование"));
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение(НСтр("ru = 'Изменение видов доступа
	                             |выполняется только через конфигуратор.
	                             |
	                             |Удаление допустимо.'"));
	
КонецПроцедуры
