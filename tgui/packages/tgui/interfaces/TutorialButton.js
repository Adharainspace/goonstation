import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export const TutorialButton = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={275}
      height={106}>
      <Window.Content scrollable>
        <Section title="test">
            help
        </Section>
      </Window.Content>
    </Window>
  );
};
