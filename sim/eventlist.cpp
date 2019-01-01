// -*- c-basic-offset: 4; tab-width: 8; indent-tabs-mode: t -*-        

#include "eventlist.h"
#include <iostream>

EventList::EventList()
    : _endtime(0),
      _lasteventtime(0),
      _num_of_flows_finished(0),
      _num_of_flows_started(0),
      _num_of_bits_received(0),
      _num_of_bits_started(0)
{
}

void
EventList::incrementNumOfBitsStarted(int64_t bits)
{
    _num_of_bits_started += bits;
}

int64_t
EventList::getNumOfBitsStarted()
{
    return _num_of_bits_started;
}

void
EventList::incrementNumOfBitsReceived(int64_t bits)
{
    _num_of_bits_received += bits;
}

int64_t
EventList::getNumOfBitsReceived()
{
    return _num_of_bits_received;
}

void
EventList::incrementNumOfFlowsStarted()
{
    _num_of_flows_started++;
}

int
EventList::getNumOfFlowsStarted()
{
    return _num_of_flows_started;
}

void
EventList::incrementNumOfFlowsFinished()
{
    _num_of_flows_finished++;
}

int
EventList::getNumOfFlowsFinished()
{
    return _num_of_flows_finished;
}

void
EventList::setEndtime(simtime_picosec endtime)
{
    _endtime = endtime;
}

bool
EventList::doNextEvent() 
{
    if (_pendingsources.empty())
	return false;
    simtime_picosec nexteventtime = _pendingsources.begin()->first;
    EventSource* nextsource = _pendingsources.begin()->second;
    _pendingsources.erase(_pendingsources.begin());
    assert(nexteventtime >= _lasteventtime);
    _lasteventtime = nexteventtime; // set this before calling doNextEvent, so that this::now() is accurate
    nextsource->doNextEvent();
    return true;
}


void 
EventList::sourceIsPending(EventSource &src, simtime_picosec when) 
{
    /*
    pendingsources_t::iterator i = _pendingsources.begin();
    while (i != _pendingsources.end()) {
	if (i->second == &src)
	    abort();
	i++;
    }
    */
    
    assert(when>=now());
    if (_endtime==0 || when<_endtime)
	_pendingsources.insert(make_pair(when,&src));
}

void 
EventList::cancelPendingSource(EventSource &src) {
    pendingsources_t::iterator i = _pendingsources.begin();
    while (i != _pendingsources.end()) {
	if (i->second == &src) {
	    _pendingsources.erase(i);
	    return;
	}
	i++;
    }
}

void 
EventList::reschedulePendingSource(EventSource &src, simtime_picosec when) {
    cancelPendingSource(src);
    sourceIsPending(src, when);
}
