/*
Design a UML class diagram for a system that models firearms and their firing mechanisms. Begin with an abstract class Firearm, which includes attributes like caliber, weight, and manufacturer, and declares an abstract method fire(), along with a concrete reload() method.
Include an abstract class TriggerMechanism with a triggerType attribute and an abstract method pullTrigger().
Add two interfaces: SemiAutomatic with the method ejectCasing(), and FullyAutomatic with the method burstFire().
Then, model a Pistol that inherits from Firearm, uses a trigger mechanism, and implements SemiAutomatic. An AssaultRifle should also inherit from Firearm, use a trigger mechanism, and implement both interfaces. A SilencedPistol is a special type of Pistol
*/
class firearms {
    int wight;
    char* caliber;
    char* manufacturer;

    virtual void fire();

    void reload(){

    }
}

class TriggerMechanism {
    protected:
        std::string triggerType

    public:
        virtual void pullTrigger()
}

class SemiAutomatic {
    public:
        virtual void ejectCasing();
};

class FullyAutomatic{
    public: 
        virtual void burstFire() = 0;
}


class Pistol : public Firearm, public semiAutomatic{
    public:
        void fire() override {
            
        }
}