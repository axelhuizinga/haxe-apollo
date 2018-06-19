package apollo.link;

import haxe.extern.EitherType;
import haxe.extern.Rest;
import js.Promise;

import apollo.util.Noise;

typedef SubscriptionObserver<T> = {
	var closed:Bool;
	var next:T->Void;
	var error:Any->Void;
	var complete:Void->Void;
}

interface Subscription {
	var closed:Bool;
	function unsubscribe():Void;
}

typedef Observer<T> = {
	@:optional var start:Subscription->Any;
	@:optional var next:T->Void;
	@:optional var error:Any->Void;
	@:optional var complete:Void->Void;
}

typedef Subscriber<T> = EitherType<SubscriptionObserver<T>->Void, EitherType<Void->Void, Subscription>>;

typedef ObservableLike<T> = {
	@:optional var subscribe:Subscriber<T>;
}

typedef ArrayLike<T> = Dynamic; // TODO

extern class Observable<T> {
	function subscribe(
		observerOrNext:EitherType<T->Void, Observer<T>>,
		?error:Any->Void,
		?complete:Void->Void
	):Subscription;

	function forEach(fn:T->Void):Promise<Noise>;
	function map<R>(fn:T->R):Observable<R>;
	function filter(fn:T->Bool):Observable<T>;
	function reduce<R:T>(fn:R->T->R, ?initialValue:R):Observable<R>;
	function flatMap<R>(fn:T->ObservableLike<R>):Observable<R>;
	function from<R>(
		observable:EitherType<Observable<R>, EitherType<ObservableLike<R>, ArrayLike<R>>>
	):Observable<R>;

	function of<R>(args:Rest<R>):Observable<R>;
}
