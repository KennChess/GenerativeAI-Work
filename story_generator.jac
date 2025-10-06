import from byllm.llm { Model }

glob llm = Model(model_name="gemini/gemini-2.0-flash", api_key=".....", verbose=False);

"""
Instructs the LLM to create a short, engaging story based on two parameters.
"""
def create_story(character: str, setting: str) -> str by llm();

walker StoryTeller {
    has character: str;
    has setting: str;

    can start with root entry;
}

impl StoryTeller.start {
    # This check ensures the walker was spawned with valid content.
    if self.character == "" or self.setting == "" {
        print("Error: Character and Setting were not provided.");
        disengage;
    }
    
    print("\n--- Story Generation Request ---");
    print(f"Character: {self.character}");
    print(f"Setting: {self.setting}");
    print("Sending request to LLM...");
    
    # This is the blocking call to the LLM. If the program hangs, 
    # the issue is here (invalid key or connection problem).
    story = create_story(self.character, self.setting);
    
    print("\n--- Generated Story ---");
    print(story);
    print("-------------------------");
}

# MAIN EXECUTION BLOCK: This is mandatory to kick off the program.
with entry:__main__ {
    # The StoryTeller is spawned with non-empty arguments, ensuring the LLM call gets context.
    root spawn StoryTeller(
        character="A tired robot archaeologist", 
        setting="A thousand-year-old floating city of Venice."
    );
}
