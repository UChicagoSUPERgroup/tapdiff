import { HelpInfoDialogModule } from './help-info-dialog.module';

describe('HelpInfoDialogModule', () => {
  let helpInfoDialogModule: HelpInfoDialogModule;

  beforeEach(() => {
    helpInfoDialogModule = new HelpInfoDialogModule();
  });

  it('should create an instance', () => {
    expect(helpInfoDialogModule).toBeTruthy();
  });
});
