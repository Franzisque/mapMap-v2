/**
 * change_event.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

function ChangeEvent(informant) {
    this._informant = informant;
    this._observers = [];
}

/**
 * register observer
 * @param observer
 */
ChangeEvent.prototype.register = function(observer) {
    this._observers.push(observer);
};

/**
 * notify all registered observers
 * @param arguments
 */
ChangeEvent.prototype.notify = function(arguments) {
    for (var index = 0; index < this._observers.length; index += 1) {
        this._observers[index](this._informant, arguments);
    }
};