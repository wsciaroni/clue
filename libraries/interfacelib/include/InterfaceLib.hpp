#ifndef INTERFACE_LIB_HPP
#define INTERFACE_LIB_HPP

class InterfaceLib {
public:
    virtual ~InterfaceLib() = default;
    virtual void doSomething() = 0;
};

#endif
